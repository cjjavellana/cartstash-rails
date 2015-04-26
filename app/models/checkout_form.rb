class CheckoutForm
  include ActiveModel::Model
  include Callbacks
  attr_accessor :payment_method, :delivery_address, :schedule
  attr_accessor :payment_methods

  validates :payment_method, :delivery_address, :schedule, :presence => true

  def self.restore(from_json)
    form = CheckoutForm.new
    form.payment_method = from_json["payment_method"]

    form
  end
end