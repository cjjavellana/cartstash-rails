class CartController < ApplicationController

  def add2cart
    do_action do
      @cart.add_item(params[:sku], get_qty)
    end

  end

  # Updates the quantity of an item in the cart
  def update_cart
    do_action do
      @cart.update_item(params[:sku], get_qty)
    end
  end

  # Removes an item from the cart
  def remove_item
    do_action do
      @cart.remove_item params[:sku]
    end
  end

  protected

    def restore_cart
      @cart = $redis.get("cart_#{session.id}")
      @cart = (@cart.nil?) ? Cart.new : Cart.restore(JSON.parse(@cart))
    end

    def do_action
      restore_cart
      yield
      $redis.set("cart_#{session.id}", @cart.to_json)
      respond_to do |format|
        format.js {render 'cart'}
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
