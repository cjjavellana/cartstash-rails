# Allows the user to add / update / remove configured delivery addresses
class DeliveryAddressController < ApplicationController
  before_action :authenticate_user!

  def index
  	@delivery_addresses = DeliveryAddress.where("user_id = ? and status = ?", current_user.id, "active")
  end

  def new
  	@countries = Country.get_countries
    @delivery_address = DeliveryAddress.new
    @return_url = params[:return_url]

    byebug
  end

  def create
    @delivery_address = DeliveryAddress.new
    @delivery_address.recipient_name = secure_params[:recipient_name]
    @delivery_address.address_line_1 = secure_params[:address_line_1]
    @delivery_address.zip_code = secure_params[:zip_code]
    @delivery_address.contact_no = secure_params[:contact_no]
    @delivery_address.country = secure_params[:country]
    @delivery_address.location_coords = secure_params[:location_coords]

    if @delivery_address.valid?
      @delivery_address.save
      render :index
    else
      render :new
    end

  end

  private
    def secure_params
      params.require(:delivery_address).permit(:recipient_name,
                                               :contact_no,
                                               :address_line_1,
                                               :address_line_2,
                                               :zip_code,
                                               :country,
                                               :location_coords)
    end
end
