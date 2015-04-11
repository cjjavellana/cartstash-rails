class BrowseProductController < CartController
  def index
    page = params[:page]
    if page.nil?
      page = 1
    end

    @products = Product.page(page)
  end
end
