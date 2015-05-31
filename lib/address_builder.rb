module AddressBuilder

  def full_address
    address = self.address_line_1
    address += ", " unless is_empty(self.address_line_2)
    address += self.address_line_2
    address += ", " unless is_empty(self.city)
    address += self.city unless is_empty(self.city)
    address += ", #{self.country}"
    address += ", #{self.zip_code}"
    address
  end

  private
    def is_empty(val)
      val.nil? || val.eql?("")
    end
end
