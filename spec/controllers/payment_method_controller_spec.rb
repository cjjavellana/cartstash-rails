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
      expect(PaymentMethod).to receive_message_chain(:where, :first).and_return(visa)

      get :edit, id: visa.id
      expect(assigns(:payment_method).first_name).to eq('Foobar')
      expect(response).to have_http_status(:success)
    end

    it "is able to update a payment method" do
      expect(PaymentMethod).to receive_message_chain(:where, :first).and_return(visa)
      expect(visa).to receive(:save).and_return(true)


      patch :update, { id: visa.id, payment_method: { credit_card_no: '####-####-####-4096', address_line_1: 'New address blvd' } }
      expect(assigns(:payment_method).address_line_1).to eq('New address blvd')
      expect(response).to have_http_status(:redirect)
    end

    it "displays the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
