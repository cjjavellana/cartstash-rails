class PaymentMethod < ActiveRecord::Base
  include CreditCardValidator
  include Callbacks
  include AddressBuilder

  belongs_to :user

  attr_accessor :expiry_date

  validates :first_name, :last_name, presence: true
  validates :credit_card_no, length: {minimum: 16, maximum: 16}
  validates :credit_card_type, :address_line_1, :city, :zip_code, :country, presence: true
  validates :security_code, length: {minimum: 3, maximum: 3}
  validates :expiry_date, length: {minimum: 7, maximum: 7}
  validates_format_of :expiry_date, :with => /(1[0-2]|0[1-9])\/(20\d{2})/i

  validate :credit_card_number

  before_validation :assemble_expiry_date
  after_initialize :after_initialize

  def after_initialize
    if !self.expiry_date.nil? and match = self.expiry_date.match(/(1[0-2]|0[1-9])\/(20\d{2})/i)
      self.expiry_month, self.expiry_year = match.captures
    end
  end

  def masked_credit_card
    if is_credit_card_no_valid
      "####-####-####-#{self.credit_card_no[12..16]}"
    end
  end

  private
    def credit_card_number
      Validator.options[:allowed_card_types] = [:visa, :master_card]
      unless is_credit_card_no_valid
        errors.add(:credit_card_no, 'is invalid')
      end
    end

    def is_credit_card_no_valid
      !self.credit_card_no.nil? and
          Validator.valid?(self.credit_card_no)
    end

    def assemble_expiry_date
      unless self.expiry_month.nil? and self.expiry_year.nil?
        self.expiry_date = "#{self.expiry_month}/#{self.expiry_year}"
      end
    end

end