class CartController < ApplicationController
  before_action :restore_cart
  after_action :persist_cart

  def add2cart
    product = Product.find_by_cs_sku(params[:sku])
    if product.qty >= get_qty
      product.update_attribute(:qty, product.qty - get_qty)
      reserved_item = ReservedItem.new(user: current_user, product: product, qty: get_qty, session_id: session.id)
      reserved_item.save
      respond_with_format { @cart.add_item(params[:sku], get_qty) }
    else
      respond_with_format
    end
  end

  # Updates the quantity of an item in the cart
  def update_cart
    product = Product.find_by_cs_sku(params[:sku])
    item = ReservedItem.where('user_id = ? and product_id = ? and session_id = ?', current_user.id,
                              product.id,
                              session.id).first
    qty = BigDecimal.new(get_qty)
    unless item.nil?
      product.update_attribute(:qty, (product.qty + item.qty) - qty) if qty > item.qty
      product.update_attribute(:qty, product.qty + (item.qty - qty)) if qty < item.qty
      item.update_attribute(:qty, qty)
    end


    respond_with_format { @cart.update_item(params[:sku], get_qty) }
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
    end
  end

end
