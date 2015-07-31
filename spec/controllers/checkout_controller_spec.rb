require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do

  describe "POST confirm order" do
    login_user

    let(:valid_checkout_form) {
      checkout_form = instance_double(CheckoutForm)

      # mocks when values are being retrieved from fields
      allow(checkout_form).to receive(:valid?).and_return(true)
      allow(checkout_form).to receive(:delivery_address)
      allow(checkout_form).to receive(:payment_option).and_return("cod")
      allow(checkout_form).to receive(:order_ref).and_return("1234567890abcdef")
      allow(checkout_form).to receive(:schedule).and_return("#{1.day.from_now.strftime("%d-%m-%Y")} 8:00")

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
      allow(checkout_form).to receive(:order_ref).and_return("1234567890abcdef")
      checkout_form
    }

    it "shows sales order items, payment methods" do
      ShopController.any_instance.stub(:categories)

      expect(PaymentMethod).to receive(:where).and_return([build(:foobar_visa)])
      expect(DeliveryAddress).to receive(:where).and_return([build(:foobar_delivery_address)])
      get :index
      expect(assigns(:payment_methods)[0].credit_card_no).to eq("4539016690974009")
      expect(assigns(:delivery_addresses)[0].country).to eq("Philippines")
    end

    it "confirms an order" do
      cart = double(Cart)
      allow(cart).to receive(:sub_total).and_return 100
      allow(cart).to receive_message_chain(:item_map, :length).and_return 5

      expect(RedisClient).to receive(:get).with("cart_#{session.id}").and_return(nil)
      expect(RedisClient).to receive(:get).with("menu_categories").and_return("{}")
      expect(Cart).to receive(:new).and_return(cart)
      expect(CheckoutForm).to receive(:new).and_return(valid_checkout_form)

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00"

      post :create, form: {
        delivery_address: delivery_address.id,
        schedule: delivery_schedule,
        payment_option: build_stubbed(:foobar_visa).id
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:create)
    end

    it "prompts for error when form is invalid" do
      cart = double(Cart)
      allow(cart).to receive(:sub_total).and_return(100)
      expect(RedisClient).to receive(:get).with("cart_#{session.id}").and_return(nil)
      expect(RedisClient).to receive(:get).with("menu_categories").and_return("{}")
      expect(Cart).to receive(:new).and_return(cart)

      delivery_schedule = "#{3.days.from_now.strftime('%d-%m-%Y')} 8:00"
      post :create, form: {
        schedule: delivery_schedule,
        payment_option: build_stubbed(:foobar_visa).id
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

end
