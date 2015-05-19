class UserProfileController < ApplicationController

  before_action :set_countries

  def index
    @user = User.find(current_user.id)
  end

  # Updates a user profile
  def update
    @user = User.find(current_user.id)

    if @user.valid?
      set_attributes
      @user.save

      flash[:notice] = "User profile successfully updated"
    end

    render :index
  end

  private
    def secure_params
      params.require(:user).permit(:first_name, :last_name, :gender, :birthdate,
                                   :address_line_1, :address_line_2, :zip, :country)
    end

    def set_attributes
      @user.assign_attributes(secure_params)
      unless secure_params[:birthdate].nil?
        begin
          @user.birthdate = Date.strptime(secure_params[:birthdate], '%m/%d/%Y')
        rescue
          print "Unable to convert to date #{secure_params[:birthdate]}"
        end
      end
    end

    def set_countries
      @countries = Country.get_countries
    end
end
