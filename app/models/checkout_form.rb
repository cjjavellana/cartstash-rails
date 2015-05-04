class CheckoutForm
  include ActiveModel::Model
  include Callbacks
  attr_accessor :payment_method, :delivery_address, :schedule
  attr_accessor :payment_methods
  attr_accessor :order_ref

  validates :payment_method, :delivery_address, :schedule, :presence => true

  def self.restore(from_json)
    form = CheckoutForm.new
    form.payment_method = from_json["payment_method"]
    form.order_ref = from_json["order_ref"]
    form
  end
end