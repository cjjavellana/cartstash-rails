class TimeDiffComponent
  attr_accessor :days, :months, :hours, :minutes, :secs

  def initialize(days, hours, minutes, secs)
    @days = days
    @hours = hours
    @minutes = minutes
    @secs = secs
  end
end

class LaunchTimer

  def self.time_to_launch
    launch_time = Time.new(2016, 3, 1, 0, 0, 0)
    now = Time.now

    time_diff = TimeDifference.between(now, launch_time)
    in_each_component = time_diff.in_each_component
    in_general = time_diff.in_general

    days = in_each_component[:days].to_i
    hours = in_general[:hours] < 10 ? "0#{in_general[:hours]}" : in_general[:hours]
    minutes = in_general[:minutes] < 10 ? "0#{in_general[:minutes]}" : in_general[:minutes]
    secs = in_general[:seconds] < 10 ? "0#{in_general[:seconds]}" : in_general[:seconds]

    TimeDiffComponent.new(days, hours, minutes, secs)
  end
end