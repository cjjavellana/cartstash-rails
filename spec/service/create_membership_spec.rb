require 'rails_helper'

describe MembershipService do

  context "Create membership" do

    let(:current_user) {
      build(:user)
    }

    let(:payment_form) {
      PaymentMethod.new(:credit_card_type => 'visa', :credit_card_no => '4539016690974009',
                                :expiry_date => '10/2015', :first_name => 'John', :last_name => 'Doe',
                                :security_code => '578', :address_line_1 => '#123-456 Make Believe Blvd',
                                :city => 'Unknown City', :zip_code => '5000', :country => 'PH')
    }

    before(:all) do
      # create the sequences
      create(:membership_sequence)
      create(:payment_sequence)
    end

    it "is able to create membership, payment and payment detail entries" do
      expect(PaymentService).to receive(:process_membership_fee!)

      MembershipService.create_membership(current_user, payment_form)
      mem = Membership.find_by_user_id(current_user.id)

      expect(mem).to_not be_nil
      expect(mem.status).to eq(Constants::Membership::ACTIVE)
    end

    it "is able to create membership with pending status when there is no payment method" do
      MembershipService.create_membership(current_user)
      mem = Membership.find_by_user_id(current_user.id)

      expect(mem).to_not be_nil
      expect(mem.status).to eq(Constants::Membership::PENDING)
    end
  end

end