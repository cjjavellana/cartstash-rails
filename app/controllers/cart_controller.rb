class CartController < ApplicationController
  before_action :restore_cart

  def add2cart
    @cart.add_item(params[:sku], get_qty)
    persist_cart_and_respond
  end

  # Updates the quantity of an item in the cart
  def update_cart
    @cart.update_item(params[:sku], get_qty)
    persist_cart_and_respond
  end

  # Removes an item from the cart
  def remove_item
    @cart.remove_item params[:sku]
    persist_cart_and_respond
  end

  protected
    def restore_cart
      @cart = $redis.get("cart_#{session.id}")
      @cart = (@cart.nil?) ? Cart.new : Cart.restore(JSON.parse(@cart))
    end

    def persist_cart_and_respond
      $redis.set("cart_#{session.id}", @cart.to_json)
      respond_to do |format|
        format.js { render 'cart' }
      end
    end

  private
    def secure_params
      params.permit(:sku, :qty)
    end

    def get_qty
      params[:qty].nil? ? 1 : params[:qty]
    end

end
