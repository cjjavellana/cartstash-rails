class PaymentMethodController < ApplicationController
  before_filter :authenticate_user!

  def index
    @payment_methods = PaymentMethod.where("user_id = ? and status = ?", current_user.id, "active")
  end

  def edit
    @payment_method = PaymentMethod.where("user_id = ? and id = ?", current_user.id, params[:id]).first
  end

end
