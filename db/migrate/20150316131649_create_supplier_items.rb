class CreateSupplierItems < ActiveRecord::Migration
  def change
    create_table :supplier_items do |t|
      t.string :supplier_sku
      t.string :cartstash_sku
      t.string :item_description
      t.string :unit_of_measure
      t.decimal :item_price, precision: 10, scale: 2
      t.decimal :min_order
      t.string :remarks
      t.references :supplier, index: true

      t.timestamps null: false
    end
    add_foreign_key :supplier_items, :suppliers
  end
end
