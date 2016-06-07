class Users::DeliveryAddressController < ApplicationController

  # Adds a new delivery address
  #
  # POST /users/deliveryaddress
  def create
    @address = DeliveryAddress.new(recipient_name: secure_address_params[:recipient_name],
                                   address_line_1: secure_address_params[:address_line_1],
                                   address_line_2: secure_address_params[:address_line_2],
                                   city: secure_address_params[:city],
                                   zip_code: secure_address_params[:zip_code],
                                   country: secure_address_params[:country],
                                   user: current_user,
                                   status: 'active')
    if @address.valid?
      @address.save
      respond_to do |format|
        format.js { render 'add_delivery_address' }
      end
    end
  end

  # Retrieves a delivery address identified by id, for
  # the purpose of displaying it on screen for update
  #
  # GET /users/deliveryaddress/:id
  def edit
    @countries = Country.get_countries
    @address = DeliveryAddress.find(params[:id])

    respond_to do |format|
      format.js { render 'edit_delivery_address' }
    end
  end

  protected

  def secure_address_params
    params.require(:delivery_address).permit(:recipient_name,
                                             :address_line_1,
                                             :address_line_2,
                                             :city,
                                             :zip_code,
                                             :country)
  end
end
