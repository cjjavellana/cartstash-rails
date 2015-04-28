require 'rails_helper'

describe SalesOrder do

  it "is able to calculate the transaction reference" do
    sales_order = build(:sales_order)

    if sales_order.valid?
      expect(sales_order.transaction_ref).to_not be_nil
    end
  end

end