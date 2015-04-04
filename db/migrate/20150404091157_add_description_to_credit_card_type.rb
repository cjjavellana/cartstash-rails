class AddDescriptionToCreditCardType < ActiveRecord::Migration
  def change
    add_column :credit_card_types, :description, :string
  end
end
