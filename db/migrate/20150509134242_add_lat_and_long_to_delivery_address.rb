class AddLatAndLongToDeliveryAddress < ActiveRecord::Migration
  def change
    add_column :delivery_addresses, :location_coords, :string
  end
end
