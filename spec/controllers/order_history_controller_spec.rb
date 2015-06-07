require 'rails_helper'

RSpec.describe OrderHistoryController, type: :controller do

  describe "Order history" do
    login_user

    let(:sales_orders) {
      [
          build_stubbed(:sales_order)
      ]
    }

    it "lists the customer's order history" do
      expect(SalesOrder).to receive_message_chain(:where, :order).and_return(sales_orders)

      get :index
      expect(assigns(:sales_orders)).to_not be_nil
      expect(response).to have_http_status :success
    end
  end

end
