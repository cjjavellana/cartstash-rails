class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@cartstash.com"
  layout 'mailer'

  def send_confirmation_mail(user, verification_token)
    @user = user
    @verification_token = verification_token
    mail(to: user.email, :subject => 'CartStash Signup Confirmation')
  end
end
