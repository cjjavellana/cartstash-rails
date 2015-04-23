class CheckoutController < CartController

  def index
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                                         current_user.id,
                                                         Constants::PaymentMethod::ACTIVE)
  end

  def delivery_and_schedule
    @checkout_form = CheckoutForm.new

    if params[:payment_method].nil?
      flash[:"alert-danger"] = "Please select a payment method"
      redirect_to checkout_index_path
    else
      @delivery_addresses = DeliveryAddress.where("user_id = ?", current_user.id)
      @checkout_form.payment_method = params[:payment_method]
    end
  end

  def confirm_order

  end

  private
    def secure_params
      params.require(:checkout_form).permit(:payment_method)
    end
end
