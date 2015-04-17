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
    else
      item.quantity += Float(qty)
    end
  end

  def update_item(sku, qty)
    item = @item_map[sku.to_sym]
    if item.nil?
      add_item sku, qty
    else
      item.quantity = Float(qty)
    end
  end

  def remove_item(sku)
    @item_map.delete sku.to_sym
  end

  def unique_items
    @item_map.length
  end

  def price
    @item_map.inject(0) { |total, (k, v)| total += v.total_price }
  end

  def empty?
    @item_map.empty?
  end

  # Restores a json encoded string to Cart object
  def self.restore(cart_json)
    cart = Cart.new
    cart_json["item_map"].map().each do |k,v|
      cart.item_map[k.to_sym] = PurchasedItem.new({:name => v["name"], :price => Float(v["price"]),
                                        :sku => v["sku"], :quantity => Float(v["quantity"])})
    end
    cart
  end

end