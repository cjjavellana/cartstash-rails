class Orders::SelectDeliveryAddressController < ShopController

  def index
    @addresses = DeliveryAddress.where('status = ?', 'active')
  end

  def select_schedule

  end
end
