class DeliveryAddress < ActiveRecord::Base
  belongs_to :user

  def address
    # some address arithmetic, :)
    "#{address_line_1 + ',' if address_line_2.nil?}
      #{address_line_2 + ',' unless address_line_2.nil?}
      #{city}, #{country}, #{zip_code}"
  end
end
