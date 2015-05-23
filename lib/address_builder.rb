module AddressBuilder

  def full_address
    "#{self.address_line_1 + ',' if self.address_line_2.nil?}" \
    "#{self.address_line_2 + ',' unless self.address_line_2.nil?}" \
    "#{self.city}, #{self.country}, #{self.zip_code}"
  end

end
