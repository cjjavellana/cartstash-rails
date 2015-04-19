class AddStatusToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :status, :string
  end
end
