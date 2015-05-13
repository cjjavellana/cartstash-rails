class DeliveryAddress < ActiveRecord::Base
  belongs_to :user

  validates :recipient_name, :address_line_1, :contact_no, presence: true
  validates :zip_code, :country, presence: true

  def address
    # some address arithmetic, :)
    "#{address_line_1 + ',' if address_line_2.nil?}
      #{address_line_2 + ',' unless address_line_2.nil?}
      #{city}, #{country}, #{zip_code}"
  end
end
