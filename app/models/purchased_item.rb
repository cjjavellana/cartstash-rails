class PurchasedItem
  attr_accessor :name, :sku, :price, :discount, :quantity

  def initialize(params = {})
    @name = params[:name]
    @sku = params[:sku]
    @price = params[:price]
    @discount = params[:quantity]
    @quantity = params[:discount]
  end
end