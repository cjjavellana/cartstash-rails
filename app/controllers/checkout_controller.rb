class CheckoutController < CartController

  def index
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                                         current_user.id,
                                                         Constants::PaymentMethod::ACTIVE)
  end

  def delivery_and_schedule
    @checkout_form = CheckoutForm.new
    @checkout_form.payment_method = params[:payment_method]
  end

  private
    def secure_params
      params.require(:checkout_form).permit(:payment_method)
    end
end