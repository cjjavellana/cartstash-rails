class SalesOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_method
  belongs_to :delivery_address

  has_many :sales_order_items

  # returns true if order_ref corresponds to an existing sales order
  def self.exists? order_ref
    not SalesOrder.find_by_transaction_ref(order_ref).nil?
  end
end
