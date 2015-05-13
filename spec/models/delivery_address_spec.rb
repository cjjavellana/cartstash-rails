require 'rails_helper'

describe DeliveryAddress do

  describe "empty delivery addresses" do
    let(:empty_delivery_address) { DeliveryAddress.new }
    specify { expect(empty_delivery_address.recipient_name).to be_nil }
  end

  describe "validation" do

    it "is not valid if mandatory fields are empty" do
      delivery_address = DeliveryAddress.new
      expect(delivery_address.valid?).to be_falsey
    end

  end
end