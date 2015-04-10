class SessionsController < Devise::SessionsController

  protected
    def after_sign_in_path_for(resources)
      # Check if the user has an active membership
      mem = Membership.find_by_user_id(current_user.id)
      if mem.nil? or !mem.status.eql?(Constants::Membership::ACTIVE)
        '/users/registrations/membership'
      else
        '/shop/browse'
      end


    end

end
