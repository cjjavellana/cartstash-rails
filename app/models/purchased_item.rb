class PurchasedItem
  attr_accessor :name, :sku, :price, :discount, :quantity

  def initialize(params = {})
    @name = params[:name]
    @sku = params[:sku]
    @price = params[:price]
    @discount = params[:discount]
    @quantity = params[:quantity]
  end

  def total_price
    @quantity * @price
  end
end