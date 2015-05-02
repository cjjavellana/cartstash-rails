class SalesOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :payment_method
  belongs_to :delivery_address

  has_many :sales_order_items

  attr_reader :transaction_ref

  after_validation :generate_transaction_ref

  private
    def generate_transaction_ref
      @transaction_ref = Digest::SHA2::hexdigest("#{self.user.email}-#{self.order_date.strftime("%d/%m/%Y %H:%M")}")[0..15]
    end
end
