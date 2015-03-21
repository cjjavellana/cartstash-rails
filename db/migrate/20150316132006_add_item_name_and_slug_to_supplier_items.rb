class AddItemNameAndSlugToSupplierItems < ActiveRecord::Migration
  def change
    add_column :supplier_items, :item_name, :string
    add_column :supplier_items, :slug, :string
  end
end
