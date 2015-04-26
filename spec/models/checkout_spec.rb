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

  it "is able to restore the CheckOutForm from a json encoded string" do
    new_checkout_form.payment_method = "COD"
    restored_form = CheckoutForm.restore(JSON.parse(new_checkout_form.to_json))
    expect(restored_form.payment_method).to eq("COD")
  end
end