class BrowseProductController < CartController
  def index
    page = params[:page]
    if page.nil?
      page = 1
    end
    restore_cart
    @products = Product.page(page)
  end
end
