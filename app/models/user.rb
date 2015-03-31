class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

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