class AddGenderAndBirthdateToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :birthdate, :date
  end
end
