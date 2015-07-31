# Handles creation of sales orders
class SalesOrderService

  def create!(sales_order, line_items)
    total = 0
    line_items.each do |item|
      item.sales_order = sales_order

      # deduct from product
      product = Product.find_by_cs_sku(item.sku)
      product.qty -= item.quantity
      product.save
      item.save
      total += item.total
    end

    sales_order.status = Constants::SalesOrderStatus::ORDER_RECEIVED
    sales_order.order_amount = total
    sales_order.save

    # Charge credit card (if selected)
    credit_card_payment(sales_order, line_items) if sales_order.payment_type == Constants::PaymentType::CREDIT_CARD
  end

  private

    def credit_card_payment(sales_order, purchased_items)
      payment_id = PaymentService.process_sales_order!(sales_order.payment_method,
                      line_items,
                      "Payment for #{sales_order.transaction_ref}",
                      "USD")
      sales_order.payment_ref = payment_id
      sales_order.paid = true
      sales_order.save
    end
end
