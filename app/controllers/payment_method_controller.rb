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

    if @payment_method.valid?
      @payment_method.assign_attributes(secure_params)
      @payment_method.save
      render :index
    else

      @card_types = CreditCardType.get_credit_card_types
      @countries = Country.get_countries

      render :edit
    end

  end

  private
    def secure_params
      params.require(:payment_method).permit(:first_name,
                                             :last_name,
                                             :credit_card_type,
                                             :credit_card_no,
                                             :address_line_1,
                                             :address_line_2,
                                             :zip_code,
                                             :country)
    end
end
