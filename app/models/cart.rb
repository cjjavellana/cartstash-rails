class Cart

  attr_accessor :item_map

  def initialize
    @item_map = {}
  end

  def empty?
    @item_map.empty?
  end
end