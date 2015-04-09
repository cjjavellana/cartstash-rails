class RegistrationsController < Devise::RegistrationsController
  include FormValidationHelper

  def confirm_account
  end

  def membership
    init_lists
    @form = CreditCardPaymentForm.new
  end

  def credit_card_payment
    @form = CreditCardPaymentForm.new(credit_card_params)
    if @form.valid?
      begin
        MembershipService.instance.create_membership(current_user, @form)
        redirect_to registration_complete
      rescue CartstashError::PaymentError => e
        byebug
        # if payment processing fails
        @form.errors = e.errors
        init_lists
        render after_sign_up_path_for resource
      end
    else
      init_lists
      render after_sign_up_path_for resource
    end
  end

  def bank_deposit
    redirect_to registration_complete
  end

  def complete
  end

  protected
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :terms_of_service)
    end

    def after_sign_up_path_for(resource)
      '/users/registrations/membership'
    end

    def after_inactive_sign_up_path_for(resource)
      '/users/registrations/confirm_account'
    end

    def after_sign_in_path_for(resources)
      '/shop/browse'
    end

    def registration_complete
      '/users/registrations/complete'
    end

    def credit_card_params
      params.require(:form).permit(:first_name, :last_name, :card_type, :credit_card_no, :security_code,
                                   :expiry_date, :address_line_1, :address_line_2, :city, :zip_code, :country)
    end

  private
    def init_lists
      # Try to get list of countries from the cache
      @countries = $redis.get('countries')
      if @countries.nil?
        # A cache-miss, retrieve it from db
        @countries = Country.all.to_json
        $redis.set('countries', @countries)
      end

      @cc_types = $redis.get('cc_types')
      if @cc_types.nil?
        @cc_types = CreditCardType.all.to_json
        $redis.set('cc_types', @cc_types)
      end

      @countries = JSON.parse(@countries)
      @cc_types = JSON.parse(@cc_types)
    end
end