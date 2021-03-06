class Cart
  include Constants
  attr_accessor :item_map, :discount

  def initialize
    @item_map = {}
    @discount = 0
  end

  def add_item(sku, qty=1)
    # check if sku is in the item_map
    item = @item_map[sku.to_sym]
    if item.nil?
      product = Product.find_by_cs_sku(sku)
      raise "#{sku} not found" if product.nil?
      item = PurchasedItem.new(
          {
              :name => product.name,
              :price => product.price,
              :sku => product.cs_sku,
              :quantity => qty,
              :image_front => product.image_front
          }
      )

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

  def reduce_qty_of(sku)
    item = @item_map[sku.to_sym]
    unless item.nil?
      new_qty = item.quantity - 1
      if new_qty > 0
        update_item sku, new_qty
      else
        remove_item sku
      end
    end
  end

  def remove_item(sku)
    @item_map.delete sku.to_sym
  end

  # Returns the number of items in cart
  def unique_items
    @item_map.length
  end

  # Returns an instance of PurchasedItem containing the qty
  # of the items ordered and the partial total
  def order_qty(sku)
    purchased_item = @item_map[sku.to_sym]

    if purchased_item.nil?
      0
    else
      purchased_item.quantity
    end

  end

  def sub_total
    @item_map.inject(0) { |total, (k, v)| total += v.total_price }
  end

  def after_discount_amount
    sub_total - @discount
  end

  def sales_tax
    (sub_total * Tax::RATE).round(2)
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
