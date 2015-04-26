require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do

  describe "POST confirm order" do
    login_user

    let(:valid_checkout_form) {
      checkout_form = instance_double(CheckoutForm)
      allow(checkout_form).to receive(:valid?).and_return(true)
      allow(checkout_form).to receive(:delivery_address=)
      allow(checkout_form).to receive(:schedule=)

      checkout_form
    }

    let(:delivery_address) {
      delivery_address = build_stubbed(:foobar_delivery_address)
    }

    let(:invalid_checkout_form) {
      checkout_form = instance_double(CheckoutForm)
      allow(checkout_form).to receive(:valid?).and_return(false)
      allow(checkout_form).to receive(:delivery_address=)
      allow(checkout_form).to receive(:schedule=)
      allow(checkout_form).to receive(:errors).and_return({:errors => ["Invalid object"]})
      checkout_form
    }

    it "confirms an order" do
      expect(RedisClient).to receive(:get).and_return(nil)
      expect(CheckoutForm).to receive(:new).and_return(valid_checkout_form)

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00-10:00"
      post :confirm_order, {delivery_address: delivery_address.id, delivery_schedule: delivery_schedule}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:confirm_order)
      expect(flash[:notice]).to be_present
    end

    it "prompts for error when form is invalid" do
      expect(RedisClient).to receive(:get).and_return(nil)
      expect(CheckoutForm).to receive(:new).and_return(invalid_checkout_form)
      expect(DeliveryAddress).to receive(:where).and_return([delivery_address])

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00-10:00"
      post :confirm_order, {delivery_address: delivery_address.id, delivery_schedule: delivery_schedule}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:delivery_and_schedule)
      expect(flash[:alert]).to be_present
    end
  end

end
