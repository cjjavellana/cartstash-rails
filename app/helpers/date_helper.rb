module DateHelper

  # Formats a date to string
  #
  # @date - The date to be formatted
  # @format - The output date format. Default is "%m/%d/%Y"
  def date_to_string(date, format="%m/%d/%Y")
    if date.nil?
      return ""
    end

    date.strftime(format)
  end

end