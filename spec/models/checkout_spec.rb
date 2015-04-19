require 'rails_helper'

describe CheckoutForm do

  let(:new_checkout_form) {
    CheckoutForm.new
  }

  it "considers a new Checkout form as an empty form" do
    expect(new_checkout_form.payment_method).to be_nil
  end

  it "considers an empty checkout form as invalid" do
    expect(new_checkout_form.valid?).to be_falsey
  end
end