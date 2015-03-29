class PrelaunchController < ApplicationController

  def index
    @time_left = LaunchTimer.time_to_launch
    render :layout => 'prelaunch'
  end

end
