class CheckoutController < CartController

  def index
    @payment_methods = PaymentMethod.where("user_id = ? AND status = ? ",
                                           current_user.id, Constants::PaymentMethod::ACTIVE)
  end

end
