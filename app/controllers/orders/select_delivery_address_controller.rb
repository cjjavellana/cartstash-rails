class Orders::SelectDeliveryAddressController < ShopController

  def index
    init
  end

  # Sets the selected delivery address and displays the
  # delivery schedule form
  #
  # /orders/selectdeliveryschedule
  def select_schedule
  end

  # Adds a new delivery address
  #
  # POST /orders/adddeliveryaddress
  def add_delivery_address
    byebug
    @address = DeliveryAddress.new(recipient_name: secure_address_params[:recipient_name],
                                   address_line_1: secure_address_params[:address_line_1],
                                   address_line_2: secure_address_params[:address_line_2],
                                   city: secure_address_params[:city],
                                   zip_code: secure_address_params[:zip_code],
                                   country: secure_address_params[:country])

    if @address.valid?
      @address.save
      render :'orders/select_delivery_address/index'
    end
  end

  private

  def init
    @addresses = DeliveryAddress.where('status = ?', 'active')
    @countries = Country.get_countries
    @delivery_address = DeliveryAddress.new
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
