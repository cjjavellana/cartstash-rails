require 'rails_helper'

RSpec.describe PrintReceiptController, type: :controller do

  describe "Show Html Receipt" do
    login_user

    let(:sales_order) {
      so = build_stubbed(:sales_order)
      allow(so).to receive(:transaction_ref).and_return("1234567890abcdef")
      allow(so).to receive(:sales_order_items).and_return([build_stubbed(:sales_order_item)])

      so
    }

    it "display the receipt" do
      allow(SalesOrder).to receive_message_chain(:where, :first).and_return(sales_order)

      get :index, {order_ref: "1234567890abcdef"}
      expect(response).to render_template(:index)
      expect(assigns(:sales_order).transaction_ref).to eq("1234567890abcdef")
    end

  end

end
