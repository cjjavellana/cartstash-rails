class AjaxLoginformController < ApplicationController

  # displays a login form for use with ajax based login
  def new
    respond_to do |format|
      format.js { render 'users/sessions/ajaxlogin' }
    end
  end

end