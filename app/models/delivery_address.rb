class DeliveryAddress < ActiveRecord::Base
  include AddressBuilder

  belongs_to :user

  validates :recipient_name, :address_line_1, :contact_no, presence: true
  validates :zip_code, :country, presence: true

end
