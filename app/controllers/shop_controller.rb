class ShopController < CartController
  def index
    page = params[:page]
    page = 1 if page.nil?
    restore_cart

    case params[:category]
      when nil
        @products = Product.page(page)
      else
        @products = Product.
            joins(:product_category).
            where(product_categories: { slug: "1-#{params[:category]}" }).page(page)
    end
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
end

