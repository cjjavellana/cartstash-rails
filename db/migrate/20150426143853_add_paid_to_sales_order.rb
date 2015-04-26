class AddPaidToSalesOrder < ActiveRecord::Migration
  def change
    add_column :sales_orders, :paid, :boolean, :default => false
    add_column :sales_orders, :payment_ref, :string
  end
end
