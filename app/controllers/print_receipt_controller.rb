class PrintReceiptController < ApplicationController

  def index
    @sales_order = SalesOrder.where("user_id = ? and transaction_ref = ?", current_user.id, params[:order_ref]).first
    render layout: 'print'
  end

end
