class PurchasedItem
  attr_accessor :name, :sku, :price, :discount, :quantity, :uom

  def initialize(params = {})
    @name = params[:name]
    @sku = params[:sku]
    @price = params[:price]
    @discount = params[:discount]
    @quantity = params[:quantity]
    @uom = params[:uom]
  end

  def total_price
    (@quantity * @price).round(2)
  end
end