class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super
    session.options[:renew] = false
  end

  def destroy
    logger.info "Logging out: #{current_user.email}; Session Id: #{session.id}"
    $redis.del "cart_#{session.id}"
    super
  end

end
