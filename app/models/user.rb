class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         # :confirmable

  validates :terms_of_service, :acceptance => {:accept => true}
end

class UserRegistrationForm
  # This class represents the input parameters when users
  # register to the site form the first time
  include ActiveModel::Model

  attr_accessor :email, :terms_of_service, :password, :confirm_password

  validates :email, :password, :confirm_password, presence: true
  validates :terms_of_service, :acceptance => true
  validate :email_must_be_unique, :password_must_match

  def save
    return false unless valid?

    user = User.new(:email => self.email, :password => self.password)
    user.save
  end

  private
    def email_must_be_unique
      user = User.find_by_email(self.email)
      unless user.nil?
        errors.add(:email, 'already exist.')
      end
    end

    def password_must_match
      if self.password != self.confirm_password
        errors.add(:password, 'do not match.')
      end
    end
end

class MembershipForm
  include ActiveModel::Model

  attr_accessor :pay_by_card, :pay_by_bank_deposit
  attr_accessor :name, :card_type, :credit_card_no, :security_code, :expiry_date
  attr_accessor :address_line_1, :address_line_2, :zip_code, :country

  validate :payment_option

  private

  def payment_option
    errors.add(:base, 'Select atleast one payment option') unless :pay_by_card || :pay_by_bank_deposit

    if :pay_by_card
      # Validate credit card details if payment is through card
      if :name.length > 19
        errors.add(:name, 'must not be more than 19 characters long')
      end


    end
  end
end