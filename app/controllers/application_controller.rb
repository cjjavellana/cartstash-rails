class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :transactions_filter

  def transactions_filter
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
