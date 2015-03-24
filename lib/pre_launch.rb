class TimeDiffComponent
  attr_accessor :days, :months, :hours, :mins, :secs
end

class PreLaunch

  def self.time_before_launch
    launch_time = Time.new(2016, 3, 1, 0, 0, 0)
    now = Time.now

    time_diff = TimeDifference.between(now, launch_time)
    in_each_component = time_diff.in_each_component
    in_general = time_diff.in_general

    diff_component = TimeDiffComponent.new
    diff_component.days = in_each_component[:days].to_i
    diff_component.hours = in_general[:hours] < 10 ? "0#{in_general[:hours]}" : in_general[:hours]
    diff_component.mins = in_general[:minutes] < 10 ? "0#{in_general[:minutes]}" : in_general[:minutes]
    diff_component.secs = in_general[:seconds] < 10 ? "0#{in_general[:seconds]}" : in_general[:seconds]

    diff_component
  end
end