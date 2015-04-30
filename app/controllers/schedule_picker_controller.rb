# This class serves as the backend controller for the schedule picker table
# to avoid relying on the client's computer date/time
class SchedulePickerController < ApplicationController

  def current_datetime

    date_choices = []
    date = Date.today
    (1..12).each do
      date_choices.push({ :key => date.strftime('%d-%m-%Y'),
                          :value => date.strftime('%d %a')
                        })
      date += 1.day
    end

    zone = ActiveSupport::TimeZone.new('Singapore')
    render json: {
               :server_time => Time.current.in_time_zone(zone).strftime('%d/%m/%Y %H:%M'),
               :current_month_year => Time.current.in_time_zone(zone).strftime('%^B %Y'),
               :next_month_year => Date.today.next_month.strftime('%^B %Y'),
               :choices => date_choices,
               :till_end_of_month => (Date.today.end_of_month - Date.today).to_i
           }
  end

end
