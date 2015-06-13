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
    @card_types = CreditCardType.get_credit_card_types
    @countries = Country.get_countries
  end

  def create
    @payment_method = PaymentMethod.new secure_params
    if @payment_method.update({ status: Constants::PaymentMethod::ACTIVE, user_id: current_user.id })
      redirect_to payment_method_index_path
    else
      @card_types = CreditCardType.get_credit_card_types
      @countries = Country.get_countries
      render :new
    end
  end

  def destroy
    @payment_method = PaymentMethod.where("user_id = ? and id = ?", current_user.id, params[:id]).first
    if @payment_method.update({ status: Constants::PaymentMethod::DELETED })
      flash[:alert] = "Payment method deleted successfully"
    else
      flash[:alert] = "An error has occurred while deleting payment method"
    end

    redirect_to payment_method_index_path
  end

  private
  def secure_params
    params_hash = params.require(:payment_method).permit(:first_name,
                                                         :last_name,
                                                         :credit_card_type,
                                                         :expiry_date,
                                                         :security_code,
                                                         :credit_card_no,
                                                         :address_line_1,
                                                         :address_line_2,
                                                         :zip_code,
                                                         :country)
    return params_hash.except(:credit_card_no) if params_hash[:credit_card_no].include?("#")
    return params_hash
  end
end