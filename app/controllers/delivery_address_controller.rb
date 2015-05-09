# Allows the user to add / update / remove configured delivery addresses
class DeliveryAddressController < ApplicationController
  before_action :authenticate_user!

  def index
  	@delivery_addresses = DeliveryAddress.where("user_id = ? and status = ?", current_user.id, "active")
  end

  def new
  	@countries = Country.get_countries
  end

end
