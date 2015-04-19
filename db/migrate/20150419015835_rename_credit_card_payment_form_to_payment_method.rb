class RenameCreditCardPaymentFormToPaymentMethod < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :credit_card_type
      t.string :credit_card_no
      t.string :security_code
      t.string :expiry_month
      t.string :expiry_year
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :zip_code
      t.string :country

      t.timestamps null: false
    end
    add_foreign_key :payment_methods, :users
  end
end
