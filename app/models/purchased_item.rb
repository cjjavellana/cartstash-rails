class PurchasedItem
  attr_accessor :name, :sku, :price, :discount, :quantity, :uom, :image_front

  def initialize(params = {})
    @name = params[:name]
    @sku = params[:sku]
    @price = params[:price]
    @discount = params[:discount]
    @quantity = params[:quantity]
    @uom = params[:uom]
    @image_front = params[:image_front] || 'http://placehold.it/50x65'
  end

  def total_price
    (@quantity * @price).round(2)
  end
end