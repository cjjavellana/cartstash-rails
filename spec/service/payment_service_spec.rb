require 'rails_helper'

describe PaymentService do

  context "Payment" do

    let(:payment_form) {
      payment_form = PaymentMethod.new(:credit_card_type => 'visa', :credit_card_no => '4539016690974009',
                                       :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                       :security_code => '578', :address_line_1 => '#123-456 Make Believe Blvd',
                                       :city => 'Unknown City', :zip_code => '5000', :country => 'PH')
    }

    let(:items) {
      items = []
      purchased_item = PurchasedItem.new
      purchased_item.name = 'Test 001'
      purchased_item.sku = '001'
      purchased_item.price = 10
      purchased_item.quantity = 10
      items.push(purchased_item)
    }

    it "can process a membership fee" do
      fake_payment = instance_double(PayPal::SDK::REST::Payment)
      allow(fake_payment).to receive(:create).and_return(true)
      allow(fake_payment).to receive(:id).and_return("PAY-12345678")

      expect(PayPal::SDK::REST::Payment).to receive(:new).and_return(fake_payment)

      payment_service = PaymentService.instance
      payment_id = payment_service.process_membership_fee!(payment_form, items, 'Unit Test', 'USD')

      expect(payment_id).to_not eq(nil)

      p = Payment.find_by_request_ref('Unit Test')
      expect(p.status).to eq('PAID')
      expect(p.payment_ref).to eq(payment_id)

      #print "Payment Id: #{payment_id} - #{p.status}"
    end

    it "can process a sales order" do
      payment = instance_double(PayPal::SDK::REST::Payment)
      allow(payment).to receive(:create).and_return(true)
      allow(payment).to receive(:id).and_return("PAY-88888888")
      expect(PayPal::SDK::REST::Payment).to receive(:new).and_return(payment)

      sales_order = build(:sales_order)
      payment_service = PaymentService.instance
      payment_ref = payment_service.process_sales_order!(sales_order, [build(:sales_order_item)], 'USD')
      expect(payment_ref).to eq("PAY-88888888")
    end
  end

end