class PaymentMethod < ActiveRecord::Base
  include CreditCardValidator
  include Callbacks
  include AddressBuilder

  belongs_to :user

  attr :expiry_date

  validates :first_name, :last_name, presence: true
  validates :credit_card_no, length: {minimum: 16, maximum: 16}
  validates :credit_card_type, :address_line_1, :zip_code, :country, presence: true
  validates :security_code, length: {minimum: 3, maximum: 3}

  validate :credit_card_number, :validate_expiry_date

  def credit_card_type=(type)
    write_attribute(:credit_card_type, type)
  end

  def credit_card_type
    case read_attribute(:credit_card_type)
      when "visa"
        "Visa"
      when "master_card"
        "Master Card"
      when "amex"
        "American Express"
    end
  end

  def expiry_date=(expiry)
    if match = expiry.match(/(1[0-2]|0[1-9])\/(20\d{2})/i)
      self.expiry_month, self.expiry_year = match.captures
    end
  end

  def expiry_date
    unless self.expiry_month.nil? and self.expiry_year.nil?
      self.expiry_date = "#{self.expiry_month}/#{self.expiry_year}"
    else
      nil
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

    def validate_expiry_date
      unless expiry_date =~  /(1[0-2]|0[1-9])\/(20\d{2})/i
        errors.add(:expiry_date, 'Expiry date must be MMYYYY')
      else
        current_year = Date.today.strftime("%Y").to_i
        if current_year > self.expiry_year.to_i
          errors.add(:expiry_date, 'Invalid Expiration Year')
        end
      end
    end
end