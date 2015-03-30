class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@cartstash.com"
  layout 'mailer'
end
