class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.references :product_category, index: true
      t.string :image_front
      t.string :image_back
      t.string :left_image
      t.string :right_image
      t.string :additional_info
      t.string :packaging
      t.decimal :price, precision: 10, scale: 2
      t.decimal :promo_price, precision: 10, scale: 2
      t.string :tags
      t.string :cs_sku
      t.string :slug

      t.timestamps null: false
    end
    add_foreign_key :products, :product_category
  end
end
