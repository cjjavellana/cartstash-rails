class PrintReceiptController < ApplicationController
  layout 'print'

  def index
    @sales_order = SalesOrder.where("user_id = ? and transaction_ref = ?", current_user.id, params[:order_ref]).first
  end

end
