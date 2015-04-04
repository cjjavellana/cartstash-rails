class PaymentService
  def process_credit_card_payment(payment_form, charges)
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

        :billing_address => billing_address
    }
  end
end

