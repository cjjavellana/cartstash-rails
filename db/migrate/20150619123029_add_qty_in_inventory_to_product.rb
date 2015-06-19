class AddQtyInInventoryToProduct < ActiveRecord::Migration
  def change
    add_column :products, :qty, :decimal, precision: 10, scale: 2
  end
end
