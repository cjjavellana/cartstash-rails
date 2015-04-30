class SalesOrderService
  include Singleton

  def create!(sales_order, line_items)
    total = 0
    line_items.each do |item|
      item.sales_order = sales_order
      item.save
      total += item.total
    end

    sales_order.order_amount = total

    # Charge credit card (if selected)
    if sales_order.payment_type == Constants::PaymentType::CREDIT_CARD
      payment_service = PaymentService.instance
      payment_id = payment_service.process_sales_order!(sales_order.payment_method, line_items, "Payment for #{sales_order.transaction_ref}", "USD")
      sales_order.payment_ref = payment_id
      sales_order.paid = true
      sales_order.status = Constants::SalesOrderStatus::PENDING_PACKING
      sales_order.save
    end
  end
end