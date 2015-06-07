class OrderHistoryController < ApplicationController

  before_action :authenticate_user!

  def index
    @sales_orders = SalesOrder.where('user_id = ?', current_user.id).order(created_at: :asc)
  end

end
