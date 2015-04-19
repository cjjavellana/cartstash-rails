require 'rails_helper'

describe PaymentMethod do

  let(:new_payment_method) {
    PaymentMethod.new
  }

  it "considers a new payment method to be invalid" do
    expect(new_payment_method.valid?).to be_falsey
  end

end