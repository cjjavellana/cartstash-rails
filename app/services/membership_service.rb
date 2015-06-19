require './lib/cartstash_error'

class MembershipService
  include CartstashError

  def self.create_membership(current_user, payment_method = nil)

    seq = SeqGenerator.instance.generate_sequence(Constants::SequenceGenerator::MEMBERSHIP, 'MEM')

    membership = Membership.new
    membership.user = current_user
    membership.status = Constants::Membership::PENDING
    membership.duration = 1
    membership.amount_paid = Constants::Membership::FEE_DEFAULT
    membership.start_date = Date.today
    membership.expiry_date = membership.start_date + 366
    membership.member_id = seq
    membership.save

    if with_credit_card?(payment_method)
      line_item = PurchasedItem.new(name: 'Membership Fee', sku: 'memfee', quantity: 1, price: Constants::Membership::FEE_DEFAULT)
      PaymentService.process_membership_fee!(payment_method, [line_item], seq, Constants::Currency::USD)
      membership.status = Constants::Membership::ACTIVE
      membership.save
    end

  end

  private
    def self.with_credit_card?(payment_method)
      not payment_method.nil? and payment_method.valid?
    end

end