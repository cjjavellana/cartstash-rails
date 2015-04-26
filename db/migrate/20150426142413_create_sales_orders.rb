class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.references :user, index: true
      t.datetime :order_date
      t.decimal :order_amount, precision: 10, scale: 2
      t.string :payment_type
      t.references :payment_method, index: true
      t.datetime :delivery_date
      t.string :time_range
      t.datetime :received_date
      t.datetime :order_dispatched_date
      t.string :remarks
      t.string :status
      t.references :delivery_address, index: true

      t.timestamps null: false
    end
    add_foreign_key :sales_orders, :users
    add_foreign_key :sales_orders, :payment_methods
    add_foreign_key :sales_orders, :delivery_addresses
  end
end
