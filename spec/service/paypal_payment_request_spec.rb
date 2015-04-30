require 'rails_helper'

describe PaymentRequest::PaypalPaymentRequest do

  it "creates a payment request" do
    credit_card = build(:foobar_visa)
    purchased_items = [build(:sales_order_item)]
    paypal_payment_request = PaymentRequest::PaypalPaymentRequest.new(credit_card, purchased_items, "Payment for groceries", "USD")
    request_hash = paypal_payment_request.create_payment_request
    expect(request_hash[:transactions][0][:amount][:total]).to eq("110.98")
  end

  it "calculates discount" do
    credit_card = build(:foobar_visa)
    sales_item = build(:sales_order_item)
    sales_item.discount = 0.10
    purchased_items = [sales_item]
    paypal_payment_request = PaymentRequest::PaypalPaymentRequest.new(credit_card, purchased_items, "Payment for groceries", "USD")
    request_hash = paypal_payment_request.create_payment_request
    expect(request_hash[:transactions][0][:amount][:total]).to eq("99.88")
  end

end