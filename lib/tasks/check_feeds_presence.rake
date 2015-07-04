require 'date'

namespace :check_feeds_presence do
	
	desc "Check if there are feeds to publish otherwise warn the admin"
	task check_feeds: :environment do
		
		time = (DateTime.now + 3.days).strftime('%Y-%m-%d %H:%M:%S')
		feeds = Feed.where("has_been_published = ? and date > ?", '0', time)
		
		if feeds.count == 0
			Mailer.trigger_error_email("Non ci sono feeds da pubblicare in data: " + (Time.now + 2.days).strftime('%d-%m-%Y').to_s).deliver
		end
	end
end

