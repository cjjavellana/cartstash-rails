class AddUomToProduct < ActiveRecord::Migration
  def change
    add_column :products, :uom, :string
  end
end
