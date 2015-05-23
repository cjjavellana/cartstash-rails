class PaymentMethodController < ApplicationController
  before_filter :authenticate_user!

  def index
    @payment_methods = PaymentMethod.where("user_id = ? and status = ?", current_user.id, "active")
  end

end
