class AddTermsOfServiceToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.boolean :terms_of_service
    end
  end
end
