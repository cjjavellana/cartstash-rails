class PaymentMethodController < ApplicationController
  before_filter :authenticate_user!

  def index
    @payment_methods = PaymentMethod.where("user_id = ? and status = ?", current_user.id, "active")
  end

  def edit
    @payment_method = PaymentMethod.where("user_id = ? and id = ?", current_user.id, params[:id]).first
    @card_types = CreditCardType.get_credit_card_types
    @countries = Country.get_countries
  end

  def update
    @payment_method = PaymentMethod.where("user_id = ? and id = ?", current_user.id, params[:id]).first


    @payment_method.assign_attributes(secure_params)
    if @payment_method.save
      redirect_to payment_method_index_path
    else
      @card_types = CreditCardType.get_credit_card_types
      @countries = Country.get_countries
      render :edit
    end
  end

  def new
    @payment_method = PaymentMethod.new
  end

  private
  def secure_params
    params_hash = params.require(:payment_method).permit(:first_name,
                                                         :last_name,
                                                         :credit_card_type,
                                                         :credit_card_no,
                                                         :address_line_1,
                                                         :address_line_2,
                                                         :zip_code,
                                                         :country)
    return params_hash.except(:credit_card_no) if params_hash[:credit_card_no].include?("#")
    return params_hash
  end
end
