class CartController < ApplicationController

  def add2cart
    restore_cart
    qty = params[:qty].nil? ? 1 : params[:qty]
    @cart.add_item(params[:sku], qty)
    $redis.set("cart_#{session.id}", @cart.to_json)

    respond_to do |format|
      format.js {}
    end
  end

  # Updates the quantity of an item in the cart
  def update_cart
    restore_cart

    qty = params[:qty].nil? ? 1 : params[:qty]
    @cart.update_item(params[:sku], qty)
    $redis.set("cart_#{session.id}", @cart.to_json)
    respond_to do |format|
      format.js {}
    end
  end

  protected

  def restore_cart
    @cart = $redis.get("cart_#{session.id}")
    @cart = (@cart.nil?) ? Cart.new : Cart.restore(JSON.parse(@cart))
  end

  private

  def secure_params
    params.permit(:sku, :qty)
  end

end
