class CreditCardPaymentForm
  include CreditCardValidator
  include ActiveModel::Model
  include Callbacks

  attr_accessor :expiry_month, :expiry_year
  attr_accessor :first_name, :last_name, :card_type, :credit_card_no, :security_code, :expiry_date
  attr_accessor :address_line_1, :address_line_2, :city, :zip_code, :country

  validates :first_name, :last_name, presence: true
  validates :credit_card_no, length: {minimum: 16, maximum: 16}
  validates :card_type, :address_line_1, :city, :zip_code, :country, presence: true
  validates :security_code, length: {minimum: 3, maximum: 3}
  validates :expiry_date, length: {minimum: 7, maximum: 7}
  validates_format_of :expiry_date, :with => /(1[0-2]|0[1-9])\/(20\d{2})/i

  validate :credit_card_number

  after_validation :split_expiry_date_to_components

  private
    def credit_card_number
      Validator.options[:allowed_card_types] = [:visa, :master_card]
      unless Validator.valid?(self.credit_card_no)
        errors.add(:credit_card_no, 'is invalid')
      end
    end

    def split_expiry_date_to_components
      if match = self.expiry_date.match(/(1[0-2]|0[1-9])\/(20\d{2})/i)
        self.expiry_month, self.expiry_year = match.captures
      end
    end
end