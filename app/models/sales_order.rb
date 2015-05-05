class SalesOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_method
  belongs_to :delivery_address

  has_many :sales_order_items

end
