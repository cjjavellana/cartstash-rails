class CheckoutController < CartController
  before_action :restore_checkout_form

  def index
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                                         current_user.id,
                                                         Constants::PaymentMethod::ACTIVE)
  end

  def delivery_and_schedule
    if params[:payment_method].nil?
      flash[:"alert-danger"] = "Please select a payment method"
      redirect_to checkout_index_path
    else
      @delivery_addresses = DeliveryAddress.where("user_id = ?", current_user.id)
      @checkout_form.payment_method = params[:payment_method]
      RedisClient.set("checkout_#{session.id}", @checkout_form.to_json)
    end
  end

  def confirm_order
    @checkout_form.delivery_address = params[:delivery_address]
    @checkout_form.schedule = params[:delivery_schedule]
    if @checkout_form.valid?
      flash[:notice] = "Your order has been placed"
    else
      @delivery_addresses = DeliveryAddress.where("user_id = ?", current_user.id)
      flash[:"alert-danger"] = @checkout_form.errors
      render "delivery_and_schedule"
    end
  end

  private
    def restore_checkout_form
      @checkout_form = RedisClient.get("checkout_#{session.id}")
      @checkout_form = @checkout_form.nil? ?
          CheckoutForm.new :
          CheckoutForm.restore(JSON.parse(@checkout_form))
    end

    def secure_params
      params.require(:checkout_form).permit(:payment_method, :delivery_address, :delivery_schedule)
    end
end
