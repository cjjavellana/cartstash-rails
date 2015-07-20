class CheckoutForm
  include ActiveModel::Model
  include Callbacks
  attr_accessor :payment_option, :delivery_address, :schedule
  attr_accessor :order_ref

  validates :payment_option, :delivery_address, :schedule, :presence => true

  def self.restore(from_json)
    CheckoutForm.new({
      payment_option: from_json["payment_option"],
      order_ref: from_json["order_ref"]
    })
  end

end
