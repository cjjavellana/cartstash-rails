class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country_code
      t.string :name
      t.string :short_name

      t.timestamps null: false
    end
  end
end
