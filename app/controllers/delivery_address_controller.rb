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
    @delivery_address = DeliveryAddress.new(secure_params)
    @delivery_address.user = current_user
    @delivery_address.status = 'active'
    @return_url = params[:return_url].equal?("") ? nil : params[:return_url]

    if @delivery_address.valid?
      @delivery_address.save

      unless @return_url.nil?
        begin
          redirect_to decrypt_return_url(@return_url)
        rescue
          # Unable to decrypt the return url
          redirect_to delivery_address_index_path
        end
      else
        redirect_to delivery_address_index_path
      end

    else
      @countries = Country.get_countries
      render :new
    end
  end

  def edit
    @delivery_address = DeliveryAddress.where("user_id = ? and id = ?", current_user.id, params[:id]).first
    @countries = Country.get_countries
  end

  def update
    @delivery_address = DeliveryAddress.where("user_id = ? and id = ?", current_user.id, params[:id]).first
    if @delivery_address.update(secure_params)
      flash[:'alert-success'] = 'Delivery address updated successfully'
      redirect_to delivery_address_index_path
    else
      @countries = Country.get_countries
      render :edit
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
