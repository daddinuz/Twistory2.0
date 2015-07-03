require 'date'

namespace :check_feeds_presence do
	desc "Check if there are feeds to publish otherwise warn the admin"
  	task check_feeds: :environment do
		
		time = DateTime.now + 2.days
		time = time.strftime('%Y-%m-%d %H:%M:%S')
     		feeds = Feed.where("has_been_published = ? and date > ?", '0', time)

			if feeds.count == 0
	
			 Mailer.no_feeds_email.deliver

			end

 end

end
	
