require 'rails_helper'

RSpec.describe PaymentMethodController, type: :controller do

  describe "Payment method" do
    login_user

    let(:visa) {
      build_stubbed(:foobar_visa)
    }

    it "displays the user's payment methods" do
      expect(PaymentMethod).to receive(:where).and_return(visa)

      get :index
      expect(assigns(:payment_methods)).to_not be_nil
      expect(response).to have_http_status(:success)
    end

    it "displays the payment method edit page" do
      expect(PaymentMethod).to receive(:where).and_return(visa)

      get :edit, id: visa.id
      expect(assigns(:payment_method).first_name).to eq('Foobar')
      expect(response).to have_http_status(:success)
    end
  end
end
