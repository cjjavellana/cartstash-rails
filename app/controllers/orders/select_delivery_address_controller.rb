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

  protected

  def address_selected_params

  end
end
