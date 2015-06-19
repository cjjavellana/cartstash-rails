class CreateReservedItems < ActiveRecord::Migration
  def change
    create_table :reserved_items do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.decimal :qty, precision: 10, scale: 2
      t.string :session_id

      t.timestamps null: false
    end
    add_foreign_key :reserved_items, :users
    add_foreign_key :reserved_items, :products
  end
end
