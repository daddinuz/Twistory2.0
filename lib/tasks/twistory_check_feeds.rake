require 'date'

	namespace :twistory_check_feeds do
	desc "Check if there are feeds"
  	task check_feeds: :environment do
		
		after_tomorrow = DateTime.now + 2
		time = after_tomorrow.strftime('%Y-%m-%d %H:%M:%S')
     		feeds = Feed.where("has_been_published = ? and date > ?", '0', time)

			if feeds.count == 0
	
			 Mailer.feeds_email.deliver

			end

 end

end
	
