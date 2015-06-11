class UserMailer < ActionMailer::Base
  default from: "twittwar95@gmail.com"
	def welcome_email
	 mail(to: "vincenzo@live.com", subject: 'Signing up!')
	end
end
