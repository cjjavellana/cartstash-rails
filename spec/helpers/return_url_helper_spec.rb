require 'rails_helper'

describe ReturnUrlHelper do
  include ReturnUrlHelper

  it "encrypts the return url" do
    encrypted = create_return_url("/shop/delivery-and-schedule")
    expect(encrypted).to_not eq("/shop/delivery-and-schedule")
  end

end