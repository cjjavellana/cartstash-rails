class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_order
end
