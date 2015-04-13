class Cart

  attr_accessor :item_map

  def initialize
    @item_map = {}
  end

  def add_item(sku, qty=1)
    # check if sku is in the item_map
    item = @item_map[sku.to_sym]
    if item.nil?
      product = Product.find_by_cs_sku(sku)
      raise "#{sku} not found" if product.nil?
      item = PurchasedItem.new({:name => product.name, :price => product.price, :sku => product.cs_sku, :quantity => qty})
      @item_map[sku.to_sym] = item
    end
  end

  def unique_items
    @item_map.length
  end

  def empty?
    @item_map.empty?
  end
end