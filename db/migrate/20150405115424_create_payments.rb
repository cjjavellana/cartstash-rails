class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :request_ref
      t.string :payment_ref
      t.string :description
      t.decimal :amount, precision: 10, scale: 2
      t.string :status
      t.datetime :cancelled_on
      t.string :cancelled_by
      t.string :cancel_reason

      t.timestamps null: false
    end
  end
end
