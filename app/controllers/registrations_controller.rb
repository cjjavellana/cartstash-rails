class RegistrationsController < Devise::RegistrationsController
  include FormValidationHelper

  def confirm_account
  end

  def membership
    init_lists
    @form = CreditCardPaymentForm.new
  end

  def credit_card_payment
    # TODO: Process credit card payment
    @form = CreditCardPaymentForm.new(credit_card_params)
    if @form.valid?
      line_item = PurchasedItem.new
      line_item.name = 'Membership Fee'
      line_item.sku = 'memfee'
      line_item.quantity = 1
      line_item.price = 999.99
      items = [line_item]

      payment_service = PaymentService.new
      begin
        seq = SeqGenerator.instance.generate_sequence('membership', 'MEM')
        payment_service.charge_credit_card!(@form, items, seq, 'USD')
        redirect_to after_membership_payment
      rescue CartstashError::PaymentError => e
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
    redirect_to after_membership_payment
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

    def credit_card_params
      params.require(:form).permit(:first_name, :last_name, :card_type, :credit_card_no, :security_code,
                                   :expiry_date, :address_line_1,  :address_line_2, :zip_code, :country)
    end

  private
    def init_lists
      # Try to get list of countries from the cache
      @countries = $redis.get('countries')
      if @countries.nil?
        # A cache-miss, retrieve it from db
        @countries = Country.all.to_json
        $redis.set('countries', @countries)
      else
        # A cache-hit, since redis can only store strings
        # We serialize active record to json when storing
        # and convert from json when retrieving from redis
        @countries = JSON.parse(@countries)
      end

      @cc_types = $redis.get('cc_types')
      if @cc_types.nil?
        @cc_types = CreditCardType.all.to_json
        $redis.set('cc_types', @cc_types)
      else
        @cc_types = JSON.parse(@cc_types)
      end
    end
end