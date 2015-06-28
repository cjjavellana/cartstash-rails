class ShopController < CartController

  before_action :product_offerings, :categories

  def index
  end

  def product_search
  end

  # The actions below are wrappers to the standard cart functions

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
    def product_offerings
      @products = RedisClient.get 'shop_index'
      if @products.nil?
        list = []
        root_categories = ProductCategory.where('product_category_id is NULL')
        root_categories.each do |f|
          products = Product.joins(:product_category).where(product_categories: {product_category_id: f.id}).limit 3
          products = [] if products.nil?
          list.push({category: f.name, slug: f.slug, products: products})
        end
        @products = list
        RedisClient.set 'shop_index', list.to_json
      else
        @products = JSON.parse @products, :symbolize_names => true
      end
    end

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

