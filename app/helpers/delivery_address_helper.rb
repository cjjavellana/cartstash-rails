module DeliveryAddressHelper

  def same_as_recipient?(delivery_address)
    return false if delivery_address.nil? or current_user.nil?
    return delivery_address.recipient_name.eql?(current_user.full_name)
  end

end
