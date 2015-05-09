require 'rails_helper'

RSpec.describe DeliveryAddressController, type: :controller do

  describe "Manage Configured Delivery Addresses" do
    login_user

    let(:delivery_address) {
      build_stubbed(:foobar_delivery_address)
    }

    it "displays the user's configured delivery addresses" do
      allow(DeliveryAddress).to receive(:where).and_return([delivery_address])
      get :index
      expect(assigns(:delivery_addresses).length).to eq(1)
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "allows a user to create new delivery address" do

    end

  end

end
