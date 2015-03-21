class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone_no
      t.string :address_line_1
      t.string :address_line_2
      t.string :zip
      t.string :country
      t.string :slug

      t.timestamps null: false
    end
  end
end
