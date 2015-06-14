class SessionsController < Devise::SessionsController

  def destroy
    $redis.del "cart_#{session.id}"
    super
  end

  protected
    def after_sign_in_path_for(resources)
      active_member? ? '/shop' : '/users/registrations/membership'
    end

    def active_member?
      mem = Membership.find_by_user_id(current_user.id)
      return true if (not mem.nil?) and mem.status.eql?(Constants::Membership::ACTIVE)
      false
    end
end
