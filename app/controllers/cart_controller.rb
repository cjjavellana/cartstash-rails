class CartController < ApplicationController
  include CartstashError

  before_action :restore_cart
  after_action :persist_cart

  def add2cart!
    product = Product.find_by_cs_sku(params[:sku])
    raise CartError("Product #{params[:sku]} not found") if product.nil?
    raise CartError("Not enough inventory to fulfill this request") if get_qty.to_i > product.qty

    @cart.add_item(params[:sku], get_qty)
  end

  # Updates the quantity of an item in the cart
  def update_cart
    product = Product.find_by_cs_sku(params[:sku])
    item = ReservedItem.where('user_id = ? and product_id = ? and session_id = ?', current_user.id,
                              product.id,
                              session.id).first
    qty = BigDecimal.new(get_qty)

    if available?(product, item, qty)
      product.update_attribute(:qty, (product.qty + item.qty) - qty)
      item.update_attribute(:qty, qty)
      respond_with_format { @cart.update_item(params[:sku], get_qty) }
    else
      flash[:error] = 'Not enough item in inventory'
      respond_with_format
    end
  end

  # Removes an item from the cart
  def remove_item
    product = Product.find_by_cs_sku(params[:sku])
    item = ReservedItem.find_by_sql(['SELECT qty FROM reserved_items where user_id = ? and product_id = ? and session_id = ?',
                                     current_user.id,
                                     product.id,
                                     session.id]).first
    unless item.nil?
      product.update_attribute(:qty, product.qty + item.qty)
      ReservedItem.delete_all(['user_id = ? and product_id = ? and session_id = ?', current_user.id,
                               product.id,
                               session.id])
    end

    respond_with_format { @cart.remove_item params[:sku] }
  end

  protected

    def restore_cart
      @cart = RedisClient.get("cart_#{session.id}")
      @cart = (@cart.nil?) ? Cart.new : Cart.restore(JSON.parse(@cart))
    end

    def persist_cart
      RedisClient.set_with_expiry("cart_#{session.id}", @cart.to_json, 2.hours.to_i)
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

    def respond_with_format
      yield if block_given?

      respond_to do |format|
        format.js { render 'cart' }
        format.json { @cart.as_json }
      end
    end

    def available?(product, reserved, qty)
      (product.qty + reserved.qty) - qty >= 0
    end
end
