class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_order

  attr_reader :total

  def total
    unless self.quantity.nil? and self.price.nil?
      write_attribute(:total, (self.quantity * self.price).round(2))
    end

    read_attribute(:total)
  end
end
