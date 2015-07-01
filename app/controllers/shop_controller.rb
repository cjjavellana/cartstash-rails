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
                 total: number_to_currency(@cart.sub_total, precision: 2, unit: '$ ')}
      respond_to do |format|
        format.json { render :json => result }
      end
    rescue CartstashError::CartError => e
      respond_to do |format|
        format.json { render :json => {error_msg: e.message}}
      end
    end
  end

  def create
    add2cart
  end

  def destroy
    remove_item
  end

  def update
    update_cart
  end

  private

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
