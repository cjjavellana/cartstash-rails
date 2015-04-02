class AddFirstAndLastNameToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :contact_number
      t.string  :address_line_1
      t.string  :address_line_2
      t.string  :country
      t.string  :zip
    end
  end
end
