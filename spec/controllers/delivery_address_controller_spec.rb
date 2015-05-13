require 'rails_helper'

RSpec.describe DeliveryAddressController, type: :controller do

  describe "Manage Configured Delivery Addresses" do
    login_user

    let(:delivery_address) {
      build_stubbed(:foobar_delivery_address)
    }

    let(:create_parameter) {
      {
          recipient_name: 'Foo Bar',
          contact_no: '+639177057221',
          address_line_1: '#10-10 Blk 101 Unknown Street',
          zip_code: '10000',
          country: 'Philippines'
      }
    }

    let(:empty_create_parameter) {
      {
          recipient_name: '',
          contact_no: ''
      }
    }

    it "displays the user's configured delivery addresses" do
      allow(DeliveryAddress).to receive(:where).and_return([delivery_address])
      get :index
      expect(assigns(:delivery_addresses).length).to eq(1)
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "does not create delivery address when parameters are empty" do
      post :create, delivery_address: empty_create_parameter
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end

    it "allows a user to create new delivery address" do
      post :create, delivery_address: create_parameter
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

  end

end
