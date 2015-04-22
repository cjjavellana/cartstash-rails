class CreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|
      t.string :recipient_name
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :zip_code
      t.string :country
      t.string :contact_no
      t.string :alternate_no
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :delivery_addresses, :users
  end
end
