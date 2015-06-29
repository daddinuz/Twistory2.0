require 'date'

	namespace :twistory_check_feeds do
	desc "Check if there are feeds"
  	task check_feeds: :environment do

		time_now = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
     		feeds = Feed.where("has_been_published = ? and date > ?", '0', time_now)

			if feeds.count = 0
	
			 Mailer.feeds_email.deliver

			end

end
	
