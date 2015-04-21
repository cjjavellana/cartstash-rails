require 'rails_helper'

describe PaymentService do

  context "Payment" do

    let(:payment_form) {
      payment_form = PaymentMethod.new(:credit_card_type => 'visa', :credit_card_no => '4539016690974009',
                                               :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                               :security_code => '578', :address_line1 => '#123-456 Make Believe Blvd',
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

    before(:each) do

    end

    it "is able to create the payment request when parameters are valid" do
      payment_helper = PaymentRequestHelper.new payment_form, items, 'Unit Test', 'USD'
      expect(payment_helper.create_payment_request[:transactions][0][:amount][:total]).to eq(100.to_s)
    end

    it "is able to apply discount" do
      items.each do |item|
        # Simulate a 10% discount
        item.discount = 0.10
      end

      payment_helper = PaymentRequestHelper.new payment_form, items, 'Unit Test', 'USD'
      payment_request = payment_helper.create_payment_request[:transactions][0][:amount]
      expect(payment_request).to include({:total => 90.0.to_s, :currency => 'USD'})
    end

    it "is able to process the transaction and return the payment id" do
      fake_payment = instance_double(PayPal::SDK::REST::Payment)
      allow(fake_payment).to receive(:create).and_return(true)
      allow(fake_payment).to receive(:id).and_return("PAY-12345678")

      expect(PayPal::SDK::REST::Payment).to receive(:new).and_return(fake_payment)

      payment_service = PaymentService.instance
      payment_id = payment_service.charge_credit_card!(payment_form, items, 'Unit Test', 'USD')

      expect(payment_id).to_not eq(nil)

      p = Payment.find_by_request_ref('Unit Test')
      expect(p.status).to eq('PAID')
      expect(p.payment_ref).to eq(payment_id)

      print "Payment Id: #{payment_id} - #{p.status}"
    end
  end

end