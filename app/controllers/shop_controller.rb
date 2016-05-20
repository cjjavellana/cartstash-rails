class ShopController < CartController
  include ActionView::Helpers::NumberHelper

  before_action :categories

  def index
    product_offerings
  end

  def product_search
  end

  def load_by_category
    # Place the result in the array because the view is iterating the categories
    # array
    @products = [Product.products_by_category(params[:category])]
    render :index
  end

  # The actions below are wrappers to the standard cart functions

  def add2cart
    begin
      add2cart!
      result = { sku: params[:sku],
                 qty: @cart.order_qty(params[:sku]),
                 total: number_to_currency(@cart.sub_total, precision: 2, unit: 'Php ')}
      respond_to do |format|
        format.json { render :json => result }
      end
    rescue CartstashError::CartError => e
      respond_to do |format|
        format.json { render :json => {error_msg: e.message}}
      end
    end
  end

  # /shop/updatecart/:q/:sku
  # :q is the action to perform - Either of the following: add, reduce, remove
  # :sku is the item identifier
  def update_cart
    @cart.add_item(params[:sku], 1) if params[:q] == "add"
    @cart.reduce_qty_of(params[:sku]) if params[:q] == "reduce"
    @cart.remove_item(params[:sku]) if params[:q] == "remove"

    respond_to do |format|
      format.json {
        render :json => update_cart_response
      }
    end
  end

  # /shop/order_summary
  def order_summary
    respond_to do |format|
      format.js { render 'cart' }
    end
  end

  private

    def update_cart_response
      item = @cart.item_map[params[:sku].to_sym]
      subtotal = item.nil? ? 0 : item.total_price
      cart_total = @cart.sub_total

      {
        sku: params[:sku],
        qty: Float(@cart.order_qty(params[:sku])),
        subtotal: number_to_currency(subtotal, unit: 'Php ', precision: 2),
        cart_total: number_to_currency(cart_total, unit: 'Php ', precision: 2)
      }
    end

    # This is an expensive computation involving multiple round trip
    # calls to the database. Idea here is that once we have retrieved
    # the top 3 items for each category, cache it so that we don't have
    # to incur the same computation cost
    def product_offerings
      @products = RedisClient.get 'shop_index'
      if @products.nil?

        list = []
        root_categories = ProductCategory.where('product_category_id is NULL')
        root_categories.each do |f|
          # Get only 3 of each kind
          products = Product.joins(:product_category).where(product_categories: {product_category_id: f.id}).limit 3
          products = [] if products.nil?
          list.push({name: f.name, slug: f.slug, products: products})
        end
        @products = list
        RedisClient.set 'shop_index', list.to_json
      else
        @products = JSON.parse @products, :symbolize_names => true
      end
    end

    # Retrieve the categories to be displayed in the left menu.
    def categories
      @categories = RedisClient.get 'menu_categories'
      if @categories.nil?
        @categories = ProductCategory.where('product_category_id is NULL').order(id: :asc)
        RedisClient.set 'menu_categories', @categories.to_json
      else
        @categories = JSON.parse @categories, :symbolize_names => true
      end
    end
end
