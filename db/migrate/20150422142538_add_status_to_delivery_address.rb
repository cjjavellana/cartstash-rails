class AddStatusToDeliveryAddress < ActiveRecord::Migration
  def change
    add_column :delivery_addresses, :status, :string
  end
end
