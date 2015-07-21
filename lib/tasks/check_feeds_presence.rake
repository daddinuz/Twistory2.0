require "date"

namespace :check_feeds_presence do
	
	desc "Check if there are feeds to publish otherwise warn the admin"
	task :check_feeds => :environment do
		
		time = (DateTime.now + 3.days)
		second_time = (DateTime.now + 4.days)
		feeds = Feed.where("date < ? and date > ?", second_time.strftime('%Y-%m-%d %H:%M:%S'), time.strftime('%Y-%m-%d %H:%M:%S'))
		
		if feeds.count == 0
			Mailer.trigger_error_email("Non ci sono feeds da pubblicare in data: " + time.strftime('%d-%m-%Y').to_s).deliver
		end
	end
end

