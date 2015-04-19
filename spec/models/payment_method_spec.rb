require 'rails_helper'

describe PaymentMethod do

  let(:new_payment_method) {
    PaymentMethod.new
  }

  it "considers a new payment method to be invalid" do
    expect(new_payment_method.valid?).to be_falsey
  end

  it "can return a masked credit card no" do
    new_payment_method.credit_card_no = '4539016690974009'
    expect(new_payment_method.masked_credit_card).to eq('####-####-####-4009')
  end
end