class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, index: true
      t.integer :duration
      t.datetime :start_date
      t.string :expiry_date
      t.string :member_id
      t.decimal :amount_paid, precision: 10, scale: 2

      t.timestamps null: false
    end
    add_foreign_key :memberships, :users
  end
end
