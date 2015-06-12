class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  # :confirmable

  validates :terms_of_service, :acceptance => {:accept => true}
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            name: auth.extra.raw_info.name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

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