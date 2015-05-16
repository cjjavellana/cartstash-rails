module SessionsHelper

  def current_user_name(current_user)
    unless current_user.first_name.nil? and current_user.last_name.nil?
      "#{current_user.first_name} #{current_user.last_name}"
    else
      ""
    end
  end

end
