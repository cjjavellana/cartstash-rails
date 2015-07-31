require 'rails_helper'

describe SalesOrder do

  it "is able to recognize a duplicate sales order" do
    expect(SalesOrder).to receive(:find_by_transaction_ref).with("abcdefghij").and_return(build_stubbed(:sales_order))
    expect(SalesOrder.exists?("abcdefghij")).to eq(true)
  end

end
