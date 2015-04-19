class CheckoutForm
  include ActiveModel::Model
  include Callbacks
  attr_accessor :payment_method, :delivery_address, :schedule

  validates :payment_method, :delivery_address, :schedule, :presence => true
end