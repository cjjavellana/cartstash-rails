class MembershipForm
  include ActiveModel::Model

  attr_accessor :pay_by_card, :pay_by_bank_deposit
  attr_accessor :name, :card_type, :credit_card_no, :security_code, :expiry_date
  attr_accessor :address_line_1, :address_line_2, :zip_code, :country

  validate :payment_option

  private

    def payment_option
      errors.add(:base, 'Select atleast one payment option') unless :pay_by_card || :pay_by_bank_deposit

      if :pay_by_card
        # Validate credit card details if payment is through card
        if :name.length > 19
          errors.add(:name, 'must not be more than 19 characters long')
        end

        
      end
    end
end