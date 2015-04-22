require 'rails_helper'

describe DeliveryAddress do

  describe "empty delivery addresses" do
    let(:empty_delivery_address) { DeliveryAddress.new }
    specify { expect(empty_delivery_address.recipient_name).to be_nil }
  end

end