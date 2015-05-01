require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do

  describe "POST confirm order" do
    login_user

    let(:valid_checkout_form) {
      checkout_form = instance_double(CheckoutForm)

      # mocks when values are being retrieved from fields
      allow(checkout_form).to receive(:valid?).and_return(true)
      allow(checkout_form).to receive(:delivery_address)
      allow(checkout_form).to receive(:payment_method).and_return("cod")
      allow(checkout_form).to receive(:order_ref).and_return("1234567890abcdef")
      allow(checkout_form).to receive(:schedule).and_return("#{1.day.from_now.strftime("%d-%m-%Y")} 8:00-10:00")

      # mocks for field assignments
      allow(checkout_form).to receive(:delivery_address=)
      allow(checkout_form).to receive(:schedule=)
      allow(checkout_form).to receive(:order_ref=)

      checkout_form
    }

    let(:delivery_address) {
      delivery_address = build_stubbed(:foobar_delivery_address)
    }

    let(:invalid_checkout_form) {
      checkout_form = instance_double(CheckoutForm)
      allow(checkout_form).to receive(:valid?).and_return(false)
      allow(checkout_form).to receive(:errors).and_return({:errors => ["Invalid object"]})
      allow(checkout_form).to receive(:delivery_address=)
      allow(checkout_form).to receive(:schedule=)

      checkout_form
    }

    before(:each) {
      expect(RedisClient).to receive(:get).with("cart_#{session.id}").and_return(nil)
      expect(RedisClient).to receive(:get).with("checkout_#{session.id}").and_return(nil)
    }

    it "shows sales order items, payment methods" do
      expect(Digest::SHA2).to receive(:hexdigest).and_return("1234567890abcdef")
      expect(PaymentMethod).to receive(:where).and_return([build(:foobar_visa)])
      get :index
      expect(assigns(:checkout_form).order_ref).to eq("1234567890abcdef")
    end

    it "confirms an order" do
      expect(CheckoutForm).to receive(:new).and_return(valid_checkout_form)

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00-10:00"
      post :confirm_order, {delivery_address: delivery_address.id, delivery_schedule: delivery_schedule}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:confirm_order)
    end

    it "prompts for error when form is invalid" do
      expect(CheckoutForm).to receive(:new).and_return(invalid_checkout_form)
      expect(DeliveryAddress).to receive(:where).and_return([delivery_address])

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00-10:00"
      post :confirm_order, {delivery_address: delivery_address.id, delivery_schedule: delivery_schedule}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:delivery_and_schedule)
    end
  end

end
