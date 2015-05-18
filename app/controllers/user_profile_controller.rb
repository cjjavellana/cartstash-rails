class UserProfileController < ApplicationController

  def index
    @countries = Country.get_countries
    @user = User.find(current_user.id)
  end

  # Updates a user profile
  def update
    @user = User.find(current_user.id)

    if @user.valid?
      @user.assign_attributes(secure_params)
      @user.save

      flash[:notice] = "User profile successfully updated"
    end

    @countries = Country.get_countries
    render :index
  end

  private
    def secure_params
      params.require(:user).permit(:first_name, :last_name, :gender, :birthdate,
                                   :address_line_1, :address_line_2, :zip, :country)
    end
end
