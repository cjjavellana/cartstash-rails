module PaymentRequest

  class PaypalPaymentRequest

    def initialize(credit_card, purchased_items, transaction_description, currency="PHP")
      @credit_card = credit_card
      @items = purchased_items
      @description = transaction_description
      @currency = currency
    end

    def create_payment_request
      assemble_request
    end

    private
      def billing_address
        {
          :line1 => @credit_card.address_line_1,
          :line2 => @credit_card.address_line_2,
          :city => @credit_card.city,
          :country_code => @credit_card.country,
          :postal_code => @credit_card.zip_code
        }
      end

      def credit_card_info
        {
          :type => @credit_card.credit_card_type,
          :number => @credit_card.credit_card_no,
          :expire_month => @credit_card.expiry_month,
          :expire_year => @credit_card.expiry_year,
          :cvv2 => @credit_card.security_code,
          :first_name => @credit_card.first_name,
          :last_name => @credit_card.last_name,
          :billing_address => billing_address
        }
      end

      def payer
        {
          :payment_method => "credit_card",
          :funding_instruments => [{:credit_card => credit_card_info}]
        }
      end

      def line_items
        items = []
        discount_amount = 0
        total_amount = 0;

        # Construct the items list and calculate the relevant charges i.e. discount, total amount
        @items.each do |item|
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
                           :price => discount_amount.round(2).to_s,
                           :currency => @currency,
                           :quantity => "1"
                       })
        end

        amount = {
            :total => (total_amount - discount_amount).round(2).to_s,
            :currency => @currency
        }

        {:amount => amount, :line_items => items}
      end

      def assemble_request
        line_items_and_amount = line_items
        {
            :intent => "sale",
            :payer => payer,
            :transactions => [
                {
                    :items_list => {
                        :items => line_items_and_amount[:line_items]
                    },
                    :amount => line_items_and_amount[:amount],
                    :description => "#{@description}"
                }
            ]
        }
      end
  end

end