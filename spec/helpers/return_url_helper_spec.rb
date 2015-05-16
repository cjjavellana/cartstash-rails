require 'rails_helper'

describe ReturnUrlHelper, type: :helper do
  include ReturnUrlHelper

  it "encrypts the return url" do
    encrypted = create_return_url("/shop/delivery-and-schedule")
    expect(encrypted).to_not eq("/shop/delivery-and-schedule")

    # Check if we can decipher the encrypted text
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = Rails.application.secrets.return_url_key
    decipher.iv = Rails.application.secrets.return_url_iv

    plain = decipher.update(Base64.decode64(encrypted)) + decipher.final
    expect(plain).to eq("/shop/delivery-and-schedule")
  end

end