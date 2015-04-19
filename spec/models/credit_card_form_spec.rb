require 'rails_helper'

describe PaymentMethod do

  context "Validation" do
    before(:each) do
      @payment_form = PaymentMethod.new(:credit_card_type => 'visa', :credit_card_no => '4539016690974009',
                                                :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                                :security_code => '578', :address_line1 => '#123-456 Make Believe Blvd',
                                                :city => 'Unknown City', :zip_code => '5000', :country => 'PH'
      )
    end

    it "must be valid" do
      expect(@payment_form.valid?).to eq(true)
    end

    it "must extract month and year from expiry_date" do
      @payment_form.valid?
      expect(@payment_form.expiry_month).to eq("10")
      expect(@payment_form.expiry_year).to eq("2015")
    end
  end
end