class AddSlugToProductCategories < ActiveRecord::Migration
  def change
    add_column :product_categories, :slug, :string
  end
end
