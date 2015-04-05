require 'rails_helper'

describe PaymentService do

  context "Payment" do

    it "must return payment id" do
      payment_form = CreditCardPaymentForm.new(:card_type => 'visa', :credit_card_no => '4539016690974009',
                                                :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                                :security_code => '578', :address_line_1 => '#123-456 Make Believe Blvd',
                                                :city => 'Unknown City', :zip_code => '5000', :country => 'PH')
      if payment_form.valid?
        items = []
        purchased_item = PurchasedItem.new
        purchased_item.name = 'Test 001'
        purchased_item.sku = '001'
        purchased_item.price = 100
        purchased_item.quantity = 10

        items.push(purchased_item)

        payment_service = PaymentService.new
        payment_id = payment_service.credit_card_pay payment_form, items, 'Unit Test', 'USD'
        print "Payment Id: #{payment_id}"
        expect(payment_id).to_not eq(nil)
      end
    end

  end

end