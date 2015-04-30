require 'rails_helper'

describe SalesOrderService do

  it "creates COD sales order" do

  end

  it "creates a credit card sales order" do
    payment_service = instance_double(PaymentService)
    allow(payment_service).to receive(:process_sales_order!).and_return("PAY-88888888")
    expect(PaymentService).to receive(:instance).and_return(payment_service)

    sales_order = build(:sales_order_cc)
    line_items = [build(:sales_order_item)]

    total_cost = 0
    line_items.each do |item|
      total_cost += item.total
    end

    sales_order_service = SalesOrderService.instance
    sales_order_service.create!(sales_order, line_items)

    expect(sales_order.id).to_not be_nil
    expect(sales_order.payment_ref).to eq("PAY-88888888")
    expect(sales_order.order_amount).to eq(total_cost)
  end

end