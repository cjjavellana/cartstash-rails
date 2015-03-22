class MainController < ApplicationController
  def index
    page = params[:pageNo]
    if page.nil?
      page = 1
    end

    @products = Product.page(page)

  end
end
