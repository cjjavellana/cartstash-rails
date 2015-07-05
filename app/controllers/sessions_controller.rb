class SessionsController < Devise::SessionsController

  respond_to :json

  def create
    super
  end

  def destroy
    logger.info "Logging out: #{current_user.name}; Session Id: #{session.id}"
    $redis.del "cart_#{session.id}"
    super
  end

end
