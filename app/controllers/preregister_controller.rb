class PreregisterController < ApplicationController

  def index
    @time_left = LaunchTimer.time_to_launch

    render :layout => 'preregister'
  end

  def show
    
  end
end
