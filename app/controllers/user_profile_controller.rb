class UserProfileController < ApplicationController

  def index
    @user = User.find(current_user.id)
  end

  def update

    render :index
  end
end
