class Mailer < ActionMailer::Base
	## The code below has been moved in development.rb and production.rb
	#default from: APP_CONFIG['email']['development']['user_name']

	def new_registration_email(user)
		@user = user

		if Rails.env.production?
			mail(:to => 'info@ragazzidel99.it', :subject => "Un nuovo utente si e' iscritto.")
		else
			mail(:to => 'twittwar95@gmail.com', :subject => "Un nuovo utente si e' iscritto.")
		end
	end

end
