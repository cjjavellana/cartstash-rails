module ReturnUrlHelper

  def create_return_url(routes_path)
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = Rails.application.secrets.return_url_key
    cipher.iv = Rails.application.secrets.return_url_iv
    encrypted = cipher.update(routes_path) + cipher.final
    Base64.encode64(encrypted)
  end

  def decrypt_return_url(encrypted)
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = Rails.application.secrets.return_url_key
    decipher.iv = Rails.application.secrets.return_url_iv
    plain = decipher.update(Base64.decode64(encrypted)) + decipher.final
    plain
  end
end