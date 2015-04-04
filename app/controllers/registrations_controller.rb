class RegistrationsController < Devise::RegistrationsController

  def confirm_account
  end

  def membership
    # Try to get list of countries from the cache
    @countries = $redis.get 'countries'
    if @countries.nil?
      # A cache-miss, retrieve it from db
      @countries = Country.all.to_json
      $redis.set 'countries', @countries
    else
      # A cache-hit, since redis can only store strings
      # We serialize active record to json when storing
      # and convert from json when retrieving from redis
      @countries = JSON.parse @countries
    end

    @cc_types = $redis.get 'cc_types'
    if @cc_types.nil?
      @cc_types = CreditCardType.all.to_json
      $redis.set 'cc_types', @cc_types
    else
      @cc_types = JSON.parse @cc_types
    end

    @form = MembershipForm.new
  end

  def process_membership_fee
    if params[:pay_by_bank_deposit]
      # TODO: Create model for storing user's membership history
      redirect_to after_membership_payment
    else
      # TODO: Process credit card payment
      @form = MembershipForm.new membership_fee_params
      if @form.valid?

        redirect_to after_membership_payment
      else
        render after_sign_up_path_for resource
      end
    end


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

    def after_membership_payment
      '/users/registrations/thankyou'
    end

    def membership_fee_params
      params.require(:membership).permit(:pay_by_card, :pay_by_bank_deposit, :name, :card_type,
                                         :credit_card_no, :security_code, :expiry_date, :address_line_1,
                                         :address_line_2, :zip_code, :country)
    end
end