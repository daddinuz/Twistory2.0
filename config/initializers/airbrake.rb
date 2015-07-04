if Rails.env.production?
	Airbrake.configure do |config|
		config.api_key = APP_CONFIG['airbrake']['production']['api_key']
		config.development_environments = []
		config.ignore_only = []
	end
end
