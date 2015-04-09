require 'rails_helper'

describe MembershipService do

  context "Create membership" do

    it "is able to create membership, payment and payment detail entries" do
      current_user = build(:user)

        payment_form = CreditCardPaymentForm.new(:card_type => 'visa', :credit_card_no => '4539016690974009',
                                                :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                                :security_code => '578', :address_line_1 => '#123-456 Make Believe Blvd',
                                                :city => 'Unknown City', :zip_code => '5000', :country => 'PH')

      MembershipService.instance.create_membership(current_user, payment_form)
      mem = Membership.find_by_user_id(current_user.id)

      expect(mem).to_not be_nil
      expect(mem.status).to eq(Constants::Membership::PAID)
    end

    it "is able to create membership with pending status when there is no payment method" do
      current_user = build(:user)
      MembershipService.instance.create_membership(current_user)
      mem = Membership.find_by_user_id(current_user.id)

      expect(mem).to_not be_nil
      expect(mem.status).to eq(Constants::Membership::PENDING)
    end
  end


end