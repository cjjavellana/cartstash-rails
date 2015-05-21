class CartController < ApplicationController
  before_action :restore_cart
  after_action :persist_cart

  def add2cart
    @cart.add_item(params[:sku], get_qty)

    respond_to do |format|
      format.js { render 'cart' }
    end
  end

  # Updates the quantity of an item in the cart
  def update_cart
    @cart.update_item(params[:sku], get_qty)

    respond_to do |format|
      format.js { render 'cart' }
    end
  end

  # Removes an item from the cart
  def remove_item
    @cart.remove_item params[:sku]

    respond_to do |format|
      format.js { render 'cart' }
    end
  end

  protected
    def restore_cart
      @cart = RedisClient.get("cart_#{session.id}")
      @cart = (@cart.nil?) ? Cart.new : Cart.restore(JSON.parse(@cart))
    end

    def persist_cart
      RedisClient.set_with_expiry("cart_#{session.id}", @cart.to_json)
    end

    def clear_session_cache
      keys = RedisClient.keys("*_#{session.id}")
      keys.each { |key| RedisClient.delete key }
    end

  private
    def secure_params
      params.permit(:sku, :qty)
    end

    def get_qty
      params[:qty] || 1
    end

end
