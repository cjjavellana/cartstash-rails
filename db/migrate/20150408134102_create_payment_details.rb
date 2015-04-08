class CreatePaymentDetails < ActiveRecord::Migration
  def change
    create_table :payment_details do |t|
      t.references :payment, index: true
      t.string :name
      t.string :sku
      t.decimal :price, precision: 10, scale: 2
      t.decimal :amount, precision: 10, scale: 2
      t.float :quantity
      t.float :discount

      t.timestamps null: false
    end
    add_foreign_key :payment_details, :payments
  end
end
