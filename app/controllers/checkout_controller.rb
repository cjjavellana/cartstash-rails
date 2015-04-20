class CheckoutController < CartController

  def index
    @checkout_form = CheckoutForm.new
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                                         current_user.id,
                                                         Constants::PaymentMethod::ACTIVE)
  end

  def delivery_and_schedule

  end
end
