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
      line_item = PurchasedItem.new
      line_item.name = 'Membership Fee'
      line_item.sku = 'memfee'
      line_item.quantity = 1
      line_item.price = Constants::Membership::FEE_DEFAULT
      items = [line_item]

      payment_service = PaymentService.new
      begin
        seq = SeqGenerator.instance.generate_sequence(Constants::SequenceGenerator::MEMBERSHIP, 'MEM')

        mem_fee = Membership.new
        mem_fee.user = current_user
        mem_fee.status = Constants::Membership::PENDING
        mem_fee.duration = 1
        mem_fee.amount_paid = Constants::Membership::FEE_DEFAULT
        mem_fee.start_date = Date.today
        mem_fee.expiry_date = mem_fee.start_date + 366
        mem_fee.save
        mem_fee.member_id = seq

        payment_service.charge_credit_card!(@form, items, seq, Constants::Currency::USD)

        mem_fee.status = Constants::Membership::PAID
        mem_fee.save

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