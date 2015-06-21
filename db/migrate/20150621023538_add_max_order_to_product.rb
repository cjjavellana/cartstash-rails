class AddMaxOrderToProduct < ActiveRecord::Migration
  def change
    add_column :products, :max_order, :decimal, precision: 10, scale: 2
  end
end
