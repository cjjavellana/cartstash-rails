class Orders::SelectDeliveryAddressController < ShopController
  before_action :authenticate_user!

  def index
    @addresses = DeliveryAddress.where('status = ? and user_id = ?', 'active', current_user.id)
    @countries = Country.get_countries
    @delivery_address = DeliveryAddress.new
    @selected_address = SelectedAddress.new
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

  protected

  def address_selected_params

  end

  def secure_address_params
    params.require(:delivery_address).permit(:recipient_name,
                                             :address_line_1,
                                             :address_line_2,
                                             :city,
                                             :zip_code,
                                             :country)
  end
end
