require 'rails_helper'

describe SalesOrderService do

  it "creates COD sales order" do

  end

  it 'creates a credit card sales order' do
    expect(PaymentService).to receive(:process_sales_order!).and_return("PAY-88888888")

    sales_order = build(:sales_order_cc)
    line_items = [build(:sales_order_item)]

    total_cost = 0
    line_items.each do |item|
      total_cost += item.total
    end

    sales_order_service = SalesOrderService.new
    sales_order_service.create!(sales_order, line_items)

    expect(sales_order.id).to_not be_nil
    expect(sales_order.payment_ref).to eq("PAY-88888888")
    expect(sales_order.order_amount).to eq(total_cost)
  end

end