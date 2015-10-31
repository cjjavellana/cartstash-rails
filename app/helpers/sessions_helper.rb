module SessionsHelper

  def current_user_name(current_user)
    if has_firstname_and_lastname?(current_user)
      "#{current_user.first_name} #{current_user.last_name}"
    else
      ""
    end
  end

  private

  def has_firstname_and_lastname?(current_user)
    !(current_user.first_name.nil? and
        current_user.last_name.nil?)
  end
end
