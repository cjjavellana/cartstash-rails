class CreditCardPaymentForm
  include ActiveModel::Model

  attr_accessor :name, :card_type, :credit_card_no, :security_code, :expiry_date
  attr_accessor :address_line_1, :address_line_2, :zip_code, :country

  validates :name, length: {maximum: 19}
  validates :credit_card_no, length: {minimum: 16, maximum: 16}
  validates :card_type, :address_line_1, :zip_code, :country, presence: true
  validates :security_code, length: {minimum: 3, maximum: 3}
  validates :expiry_date, length: {minimum: 7, maximum: 7}
  validates_format_of :expiry_date, :with => /(1[0-2]|0[1-9])\/(20\d{2})/i

end