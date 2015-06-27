class AddParentCategoryToProductCategory < ActiveRecord::Migration
  def change
    add_reference :product_categories, :product_category, index: true
    add_foreign_key :product_categories, :product_categories
  end
end
