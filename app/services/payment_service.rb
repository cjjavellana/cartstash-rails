require 'paypal-sdk-rest'
require './lib/cartstash_error'

class PaymentService
  include PayPal::SDK::REST
  include CartstashError

  def credit_card_pay(payment_form, purchased_items, transaction_id, currency='PHP')
    
    billing_address = {
        :line1 => payment_form.address_line_1,
        :line2 => payment_form.address_line_2,
        :city => payment_form.city,
        :country_code => payment_form.country,
        :postal_code => payment_form.zip_code
    }

    credit_card = {
        :type => payment_form.card_type,
        :number => payment_form.credit_card_no,
        :expire_month => payment_form.expiry_month,
        :expire_year => payment_form.expiry_year,
        :cvv2 => payment_form.security_code,
        :first_name => payment_form.first_name,
        :last_name => payment_form.last_name,
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
    purchased_items.each do |item|
      items.push({
                       :name => item.name,
                       :sku => item.sku,
                       :price => item.price.to_s,
                       :currency => currency,
                       :quantity => item.quantity
                   })
      total_amount += item.price
      if item.discount
        discount_amount += item.price - (item.price * item.discount)
      end
    end

    if discount_amount > 0
      items.insert({
                       :name => 'Discount',
                       :sku => 'discount',
                       :price => discount_amount.to_s,
                       :currency => currency,
                       :quantity => "1"
                   })
    end

    amount = {
        :total => (total_amount - discount_amount).to_s,
        :currency => currency
    }

    @payment = Payment.new({
                               :intent => "sale",
                               :payer => payer,
                               :transactions => [
                                   {
                                       :items_list => {
                                           :items => items
                                       },
                                       :amount => amount,
                                       :description => "Payment for transaction #{transaction_id}"
                                   }
                               ]
                           })

    if @payment.create
      @payment.id
    else
      raise PaymentError, @payment.error
    end
  end
end

