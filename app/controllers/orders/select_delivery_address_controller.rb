class Orders::SelectDeliveryAddressController < ShopController

  def index
    @addresses = DeliveryAddress.where('status = ?', 'active')
    @countries = Country.get_countries
    @delivery_address = DeliveryAddress.new
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
  end
end
