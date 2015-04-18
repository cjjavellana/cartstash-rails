class ShopController < CartController
  def index
    page = params[:page]
    if page.nil?
      page = 1
    end
    restore_cart
    @products = Product.page(page)
  end

  # The actions below are a wrapper to the standard cart functions

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

