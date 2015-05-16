# Allows the user to add / update / remove configured delivery addresses
class DeliveryAddressController < ApplicationController
  include ReturnUrlHelper

  before_action :authenticate_user!

  def index
    @delivery_addresses = DeliveryAddress.where("user_id = ? and status = ?", current_user.id, "active")
  end

  def new
    @countries = Country.get_countries
    @delivery_address = DeliveryAddress.new
    @return_url = params[:return_url] unless params[:return_url].nil?
  end

  def create
    @delivery_address = DeliveryAddress.new
    @delivery_address.recipient_name = secure_params[:recipient_name]
    @delivery_address.address_line_1 = secure_params[:address_line_1]
    @delivery_address.zip_code = secure_params[:zip_code]
    @delivery_address.contact_no = secure_params[:contact_no]
    @delivery_address.country = secure_params[:country]
    @delivery_address.location_coords = secure_params[:location_coords]
    @delivery_address.user = current_user
    @delivery_address.status = "active"

    if @delivery_address.valid?
      @delivery_address.save

      return_url = params[:return_url].equal?("") ? nil : params[:return_url]
      unless return_url.nil?
        begin
          redirect_to decrypt_return_url(return_url)
        rescue
          # Unable to decrypt the return url
          render :index
        end
      else
        render :index
      end

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
