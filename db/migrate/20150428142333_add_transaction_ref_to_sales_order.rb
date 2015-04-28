class AddTransactionRefToSalesOrder < ActiveRecord::Migration
  def change
    add_column :sales_orders, :transaction_ref, :string
  end
end
