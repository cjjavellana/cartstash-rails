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

  it "categorizes the expiry date into month and year components" do
    p = PaymentMethod.new
    p.expiry_date = '12/2015'
    expect(p.expiry_month).to eq('12')
    expect(p.expiry_year).to eq('2015')
  end

  it "fails validation when expiry date is wrong format" do
    p = PaymentMethod.new
    p.expiry_date = '15/xxxx'
    expect(p.valid?).to be_falsey
    expect(p.errors[:expiry_date][0]).to eq("Expiry date must be MMYYYY")
  end

  it "fails validation when expiry year is less than current year" do
    expect(Date).to receive_message_chain(:today, :strftime).and_return("2015")
    p = PaymentMethod.new
    p.expiry_date = '12/2014'
    expect(p.valid?).to be_falsey
    expect(p.errors[:expiry_date][0]).to eq("Invalid Expiration Year")
  end
end