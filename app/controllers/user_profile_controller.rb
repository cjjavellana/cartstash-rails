class UserProfileController < ApplicationController

  before_filter :authenticate_user!
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

  def update_password
    @user = User.find(current_user.id)

    if @user.update_with_password(password_update_params)
      sign_in @user, :bypass => true
      flash[:notice] = "Password successfully updated"
    end

    respond_to do |format|
      format.js { render 'changepassword' }
    end

  end

  private
    def secure_params
      params.require(:user).permit(:first_name, :last_name, :gender, :birthdate,
                                   :address_line_1, :address_line_2, :zip, :country)
    end

    def password_update_params
      params.require(:user).permit(:password, :password_confirmation, :current_password)
    end

    def set_attributes
      @user.assign_attributes(secure_params)
      unless secure_params[:birthdate].nil? or secure_params[:birthdate].eql?("")
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
