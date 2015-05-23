require 'rails_helper'

RSpec.describe PaymentMethodController, type: :controller do

  describe "Payment method" do
    login_user

    it "displays the user's payment methods" do
      expect(PaymentMethod).to receive(:where).and_return(build_stubbed(:foobar_visa))

      get :index
      expect(assigns(:payment_methods)).to_not be_nil
      expect(response).to have_http_status(:success)
    end
  end



end
