# This class serves as the backend controller for the schedule picker table
# to avoid relying on the client's computer date/time
class SchedulePickerController < ApplicationController

  # URI: /delivery-time/:date
  #
  # Description:
  #   Takes in a date and returns the available delivery time for
  #   that day.
  #
  # Examples:
  #   This function returns an error when the parameter date is less than
  #   the current date or is more than two weeks in the future from the
  #   current date.
  #
  #   If parameter date is current date, it returns all available two-hour
  #   window from the current time until 10pm.
  #
  #   If parameter date is within the next day till two weeks from now, it
  #   returns the available delivery window from 8am until 10pm
  def available_time
    param_date = Date.strptime(params[:date], '%Y-%m-%d')
    case
    when param_date <  Date.today
      render json: {error: "Date cannot be less than current date"}
    when param_date >= ( Date.today + 2.weeks)
      render json: {error: "Unable to schedule delivery two weeks in advance"}
    else
      delivery_window = []
      starttime = DateTime.strptime("#{params[:date]} +08:00", '%Y-%m-%d %z').change({hour: 8})
      endtime = DateTime.strptime("#{params[:date]} +08:00", '%Y-%m-%d %z').change({hour: 22})

      if param_date ==  Date.today
        starttime = (DateTime.now + 2.hours).change({min: 0, sec: 0})
      end

      while starttime < endtime
        delivery_window.push({
          startime: starttime.strftime('%H:%M'),
          endtime:  (starttime + 2.hours).strftime('%H:%M')
        })
        starttime += 2.hours
      end

      render json: {error: "No available slot for today"} if delivery_window.empty?
      render json: {timeslot: delivery_window} unless delivery_window.empty?
    end #case
  end # available_time
end #SchedulePickerController
