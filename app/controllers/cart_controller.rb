class CartController < ApplicationController

  def add2cart
    cart_items = session[:cart_items] || {}

    # check if we already have that sku in the cart
    item = cart_items[params[:sku].to_sym]
    unless item.nil?
      # item already in cart
      item["quantity"] = Integer(item["quantity"]) + 1
    else
      # item not in cart yet. retrieve details from database
      product = Product.find_by_cs_sku(params[:sku])
      item = {"name" => product.name, "price" => product.price.to_s, "sku" => product.cs_sku, "quantity" => 1}
      cart_items[params[:sku].to_sym] = item
    end

    if session[:cart_items].nil?
      session[:cart_items] = cart_items
    end

    respond_to do |format|
      format.js {}
    end
  end


  private
    def secure_params
      params.permit(:sku)
    end

end
