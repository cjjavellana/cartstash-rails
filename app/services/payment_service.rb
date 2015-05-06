require 'paypal-sdk-rest'
require './lib/cartstash_error'

# Handles credit card payment processing
class PaymentService
  include Singleton
  include CartstashError
  include PaymentRequest

  # Processes the credit card payment request through paypal
  # === Argument
  # * <tt>payment_form</tt> - An instance of CreditCardPaymentForm
  # * <tt>purchased_items</tt> - An array containing an instance of PurchasedItem
  # * <tt>transaction_id</tt> - A string identifying this payment request
  # * <tt>currency</tt> - A string indicating the currency to be used; Defaults to Philippine Peso (PHP)
  # === Exceptions
  # * <tt>CartstashError::PaymentError</tt> when the payment is unsuccessful
  def process_membership_fee!(payment_form, purchased_items, transaction_id, currency='PHP')
    Payment.transaction do
      payment_request = PaypalPaymentRequest.new(payment_form,
                                                 purchased_items,
                                                 "Payment for #{transaction_id}",
                                                 currency)
      request_hash = payment_request.create_payment_request
      @payment = PayPal::SDK::REST::Payment.new(request_hash)

      # Create the payment header
      p = Payment.new
      p.amount = get_amount_from_request_hash(request_hash)
      p.description = "Payment for #{transaction_id}"
      p.request_ref = transaction_id
      p.save

      # Create the payment detail
      purchased_items.each do |t|
        payment_detail = PaymentDetail.new(:name => t.name,
                                           :sku => t.sku,
                                           :price => BigDecimal(t.price, 2),
                                           :quantity => Float(t.quantity),
                                           :discount => t.discount,
                                           :payment => p)
        payment_detail.save
      end

      if @payment.create
        p.update({:status => 'PAID', :payment_ref => @payment.id})
        @payment.id
      else
        raise PaymentError, @payment.error
      end

    end
  end

  def process_sales_order!(credit_card, sales_order_items, description, currency='PHP')
    request = PaypalPaymentRequest.new(credit_card, sales_order_items, description, currency)

    paypal_payment = PayPal::SDK::REST::Payment.new(request)
    if paypal_payment.create
      paypal_payment.id
    else
      raise PaymentError, paypal_payment.error
    end

  end

  private
    def get_amount_from_request_hash(request_hash)
      request_hash[:transactions][0][:amount][:total]
    end
end