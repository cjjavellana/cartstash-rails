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
      $redis.set("checkout_#{session.id}", @checkout_form.to_json)
    end
  end

  def confirm_order

  end

  private
    def restore_checkout_form
      @checkout_form = $redis.get("checkout_#{session.id}")
      @checkout_form = @checkout_form.nil? ?
          CheckoutForm.new :
          CheckoutForm.restore(JSON.parse(@checkout_form))
    end

    def secure_params
      params.require(:checkout_form).permit(:payment_method)
    end
end
