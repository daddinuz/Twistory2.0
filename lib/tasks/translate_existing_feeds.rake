require 'google/api_client'
require 'json'

namespace :translate_exisiting_feeds do
  desc "Translate existing feeds"

  task translate_exisiting_feeds: :environment do

	  google_client = Google::APIClient.new(
		  :application_name => APP_CONFIG['google']['production']['application_name'],
		  :key 		  => APP_CONFIG['google']['production']['key'],
		  :application_version => '1.0.0',
		  :authorization => nil
	  )
		
	  translate = google_client.discovered_api('translate', 'v2')

	  feeds = Feed.all
	  i = 0
	  
	  feeds.each do |feed|

		  result = google_client.execute(
		      :api_method => translate.translations.list,
		      :parameters => {
		      'format' => 'text',
		      'source' => 'it',
		      'target' => 'en',
		      'q' => feed.feed_text
		    }
		  )

		  parsed = JSON.parse(result.data.to_json)
		  # Example of data returned 
		  # {"translations":[{"translatedText":"This is a pen"}]}'

		  english_translation = parsed["translations"][0]["translatedText"]

		  feed.feed_text_english = english_translation
		  feed.save(validate: false)
		
		  i = i+1
		  puts i

	  end
	
	end
end
