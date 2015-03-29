class RegistrationsController < Devise::RegistrationsController

  protected
    def after_sign_up_path_for(resource)
      '/users/registrations/membership'
    end

    def after_inactive_sign_up_path_for(resource)
      '/users/registrations/unconfirmed'
    end
end