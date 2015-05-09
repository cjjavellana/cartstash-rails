class CheckoutController < CartController
  before_action :authenticate_user!, :restore_checkout_form

  def index
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                           current_user.id, Constants::PaymentMethod::ACTIVE)
  end

  def delivery_and_schedule
    if missing_payment_method?
      flash[:"alert-danger"] = "Please select a payment method"
      redirect_to checkout_index_path
    else
      restore_delivery_address

      unless params[:payment_method].nil?
        @checkout_form.payment_method = params[:payment_method]
        RedisClient.set_with_expiry("checkout_#{session.id}", @checkout_form.to_json)
      end
    end
  end

  def confirm_order
    @checkout_form.delivery_address = params[:delivery_address]
    @checkout_form.schedule = params[:delivery_schedule]

    if @checkout_form.valid?
      unless sales_order_exists?
        sales_order = create_sales_order
        sales_order_service = SalesOrderService.instance
        sales_order_service.create!(sales_order, create_line_items)

        clear_session_cache
      end
    else
      restore_delivery_address
      render "delivery_and_schedule"
    end
  end

  private
  def create_sales_order
    sales_order = SalesOrder.new
    sales_order.delivery_address = DeliveryAddress.where("user_id = ? and id = ?", current_user.id, @checkout_form.delivery_address).first
    sales_order.user = current_user
    sales_order.order_date = DateTime.current
    sales_order.transaction_ref = @checkout_form.order_ref

    if @checkout_form.payment_method.downcase == Constants::PaymentType::CASH_ON_DELIVERY.downcase
      sales_order.payment_type = Constants::PaymentType::CASH_ON_DELIVERY
    else
      sales_order.payment_type = Constants::PaymentType::CREDIT_CARD
      sales_order.payment_method = PaymentMethod.where("user_id = ? and id = ?", current_user.id, @checkout_form.payment_method).first
    end

    sales_order.time_range = @checkout_form.schedule.gsub(/^(.*?)\s/, "")
    sales_order.delivery_date = DateTime.strptime(@checkout_form.schedule.gsub(/\s-.*$/, ""), "%d-%m-%Y %H:%M ").change(:offset => "+8:00")
    sales_order
  end

  def create_line_items
    items = []
    @cart.item_map.map.each do |k, v|
      product = Product.find_by_cs_sku(v.sku)
      sales_item = SalesOrderItem.new
      sales_item.sku = product.cs_sku
      sales_item.name = product.name
      sales_item.price = product.price
      sales_item.quantity = v.quantity
      sales_item.discount = product.discount
      items.push(sales_item)
    end
    items
  end

  def missing_payment_method?
    params[:payment_method].nil? and @checkout_form.payment_method.nil?
  end

  def restore_delivery_address
    @delivery_addresses = DeliveryAddress.where("user_id = ?", current_user.id)
  end

  def restore_checkout_form
    @checkout_form = RedisClient.get("checkout_#{session.id}")
    @checkout_form = @checkout_form.nil? ? CheckoutForm.new : CheckoutForm.restore(JSON.parse(@checkout_form))
    generate_order_ref if @checkout_form.order_ref.nil?
  end

  def secure_params
    params.require(:checkout_form).permit(:payment_method, :delivery_address, :delivery_schedule)
  end

  def generate_order_ref
    item_count = @cart.item_map.length
    cart_amount = @cart.sub_total
    current_time = DateTime.current.strftime("%d/%m/%Y %H:%M")
    @checkout_form.order_ref = Digest::SHA2.hexdigest("#{current_user.email}-#{cart_amount}-#{item_count}-#{current_time}")[0..20]
  end

  def sales_order_exists?
    not SalesOrder.find_by_transaction_ref(@checkout_form.order_ref).nil?
  end
end
