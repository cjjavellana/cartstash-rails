require 'paypal-sdk-rest'
require './lib/cartstash_error'

class PaymentService
  include Singleton
  include CartstashError

  # Processes the credit card payment request through paypal
  # === Argument
  # * <tt>payment_form</tt> - An instance of CreditCardPaymentForm
  # * <tt>purchased_items</tt> - An array containing an instance of PurchasedItem
  # * <tt>transaction_id</tt> - A string identifying this payment request
  # * <tt>currency</tt> - A string indicating the currency to be used; Defaults to Philippine Peso (PHP)
  # === Exceptions
  # * <tt>CartstashError::PaymentError</tt> when the payment is unsuccessful
  def charge_credit_card!(payment_form, purchased_items, transaction_id, currency='PHP')
    Payment.transaction do
      payment_request = PaymentRequestHelper.new payment_form, purchased_items, transaction_id, currency
      @payment = PayPal::SDK::REST::Payment.new(payment_request.create_payment_request)

      # Create the payment header
      p = Payment.new
      p.amount = BigDecimal(payment_request.amount[:total])
      p.description = "Payment for #{transaction_id}"
      p.request_ref = transaction_id
      p.save

      # Create the payment detail
      purchased_items.each do |t|
        payment_detail = PaymentDetail.new(:name => t.name, :sku => t.sku, :price => BigDecimal(t.price, 2),
          :quantity => Float(t.quantity), :discount => t.discount, :payment => p)
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
end

class PaymentRequestHelper

  attr_reader :amount

  def initialize(payment_form, purchased_items, transaction_id, currency='PHP')
    @payment_form = payment_form
    @purchased_items = purchased_items
    @transaction_id = transaction_id
    @currency = currency
  end

  def create_payment_request
    if @payment_form.valid?
      billing_address = {
          :line1 => @payment_form.address_line_1,
          :line2 => @payment_form.address_line_2,
          :city => @payment_form.city,
          :country_code => @payment_form.country,
          :postal_code => @payment_form.zip_code
      }

      credit_card = {
          :type => @payment_form.card_type,
          :number => @payment_form.credit_card_no,
          :expire_month => @payment_form.expiry_month,
          :expire_year => @payment_form.expiry_year,
          :cvv2 => @payment_form.security_code,
          :first_name => @payment_form.first_name,
          :last_name => @payment_form.last_name,
          :billing_address => billing_address
      }

      payer = {
          :payment_method => "credit_card",
          :funding_instruments => [{:credit_card => credit_card}]
      }

      items = []
      discount_amount = 0
      total_amount = 0;

      # Construct the items list and calculate the relevant charges i.e. discount, total amount
      @purchased_items.each do |item|
        price = item.price * item.quantity
        items.push({
                       :name => item.name,
                       :sku => item.sku,
                       :price => price.to_s,
                       :currency => @currency,
                       :quantity => item.quantity
                   })
        total_amount += price
        if item.discount
          discount_amount += (price * item.discount)
        end
      end

      if discount_amount > 0
        items.insert({
                         :name => 'Discount',
                         :sku => 'discount',
                         :price => discount_amount.to_s,
                         :currency => @currency,
                         :quantity => "1"
                     })
      end

      @amount = {
          :total => (total_amount - discount_amount).to_s,
          :currency => @currency
      }

      {
          :intent => "sale",
          :payer => payer,
          :transactions => [
              {
                  :items_list => {
                      :items => items
                  },
                  :amount => @amount,
                  :description => "Payment for transaction #{@transaction_id}"
              }
          ]
      }
    else
      raise PaymentError, @payment_form.error
    end
  end

end