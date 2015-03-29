class PreregisterController < ApplicationController

  def index
    @time_left = LaunchTimer.time_to_launch
    render :layout => 'preregister'
  end

  def new
    @registration_form = UserRegistrationForm.new
  end

  def create
    @registration_form = UserRegistrationForm.new(user_params)
    if @registration_form.valid?
      @registration_form.save
      flash[:success] = 'Account Successfully Created'
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require('user_registration_form').permit(:email, :password, :confirm_password, :terms_of_service)
    end
end
