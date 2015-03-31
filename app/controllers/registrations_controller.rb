class RegistrationsController < Devise::RegistrationsController

  def confirm_account
  end

  protected
    def sign_up_params
      print params
      params.require(:user).permit(:email, :password, :password_confirmation, :terms_of_service)
    end

    def after_sign_up_path_for(resource)
      '/users/registrations/membership'
    end

    def after_inactive_sign_up_path_for(resource)
      '/users/registrations/confirm_account'
    end
end