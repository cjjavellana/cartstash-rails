class CreateSalesOrderItems < ActiveRecord::Migration
  def change
    create_table :sales_order_items do |t|
      t.references :sales_order, index: true
      t.string :sku
      t.string :name
      t.float :quantity
      t.decimal :price, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :status
      t.string :remarks
      t.float :discount

      t.timestamps null: false
    end
    add_foreign_key :sales_order_items, :sales_orders
  end
end
