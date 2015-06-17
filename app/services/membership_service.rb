require './lib/cartstash_error'

class MembershipService
  include Singleton
  include CartstashError

  def create_membership(current_user, payment_method = nil)

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

    if payment_method.nil?
      # user opted to pay through bank deposit
    else
      if payment_method.valid?
        PaymentService.process_membership_fee!(payment_method, [create_membership_fee_line_item], seq, Constants::Currency::USD)
        membership.status = Constants::Membership::ACTIVE
        membership.save
      end
    end
  end

  private
  def create_membership_fee_line_item
    line_item = PurchasedItem.new
    line_item.name = 'Membership Fee'
    line_item.sku = 'memfee'
    line_item.quantity = 1
    line_item.price = Constants::Membership::FEE_DEFAULT
    line_item
  end
end