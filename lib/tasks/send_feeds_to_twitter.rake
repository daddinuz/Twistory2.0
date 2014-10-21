require 'twitter'

namespace :send_feeds_to_twitter do

  desc "Send Feeds to LaGrandeGuerra Twitter Channel"
  task send_feeds_italian: :environment do
		
    # Remember that the server time is UTC
    time_now = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
    
    box = Feed.where("has_been_published = ? and date < ?", '0', time_now)
    ctrl = box.length
    
    if ctrl > 0
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = APP_CONFIG['twitter']['development']['consumer_key']
        config.consumer_secret     = APP_CONFIG['twitter']['development']['consumer_secret']
        config.access_token        = APP_CONFIG['twitter']['development']['access_token']
        config.access_token_secret = APP_CONFIG['twitter']['development']['access_token_secret']
      end
		  
      i = 0
    
      while i != ctrl do
      
        feed_text = box[i].feed_text
        
	      # Dead code
        # feed_text.gsub(/'/){ "`" }
        # feed_text.gsub(/"/){ "`" }

        # Appending the #LaGrandeGuerra hashtag
        feed_text = feed_text + " #LaGrandeGuerra"
        
        twitter_response = nil

        # Case 1: no pictures are posted
        if !box[i].feed_image.present?

	        if feed_text.length <= 140
            twitter_response = client.update(feed_text)
              
            # Verify that twitter_response is not blank
            if !twitter_response.blank? and !twitter_response.id.blank?
	            box[i].update_attribute(:has_been_published, 1)

              # If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
              # TODO: we should also trigger an error email to info@ragazzidel99.it
            else
              box[i].update_attribute(:has_been_published, -1)
            end
          else
	          # TODO: trigger an error email to info@ragazzidel99.it
	        end
	        
	      # Case 2: pictures are posted  
        else 
        
          # When sending pictures, Twitter creates a http URL that may count towards up to 23 characters
          # As a result, only 140 - 23 = 117 characters are left
	        if feed_text.length <= 117
            twitter_response = client.update_with_media(feed_text, File.new(box[i].feed_image.path))

            # Verify that twitter_response is not blank
            if !twitter_response.blank? and !twitter_response.id.blank?
	            box[i].update_attribute(:has_been_published, 1)

              # If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
              # TODO: we should also trigger an error email to info@ragazzidel99.it
            else
              box[i].update_attribute(:has_been_published, -1)
            end
          else
	          # TODO: trigger an error email to info@ragazzidel99.it
          end
          
        end

        # TODO: Use rescue for exception handling in case and error occurs. 
        # For instance, when accidentally sending feeds to Twitter with length greater than 140, 
        # the twitter gem produces a fatal error and exits the task immediately with Twitter::Error::Forbidden: Status is over 140 characters. 

        ## use the line below to debug:                              
        ## puts "\n\nctrl: #{ctrl}, i: #{i}\ntime now: #{time_now}\nhas_been: #{box[i].has_been_published}\nfeed text: #{box[i].feed_text}"
			  	
        i = i+1
      
      end # end while loop # 
    end # end initial if statement #   
  end # end send_feeds_italian task #


  desc "Send Feeds to WW1fromItaly Twitter Channel"
  task send_feeds_english: :environment do
		
    # Remember that the server time is UTC
    time_now = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
    
    box = Feed.where("has_been_published_english = ? and date < ?", '0', time_now)
    ctrl = box.length
    
    if ctrl > 0
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = APP_CONFIG['twitter']['production_english']['consumer_key']
        config.consumer_secret     = APP_CONFIG['twitter']['production_english']['consumer_secret']
        config.access_token        = APP_CONFIG['twitter']['production_english']['access_token']
        config.access_token_secret = APP_CONFIG['twitter']['production_english']['access_token_secret']
      end
		  
      i = 0
    
      while i != ctrl do
      
        feed_text = box[i].feed_text_english

	      if feed_text.blank?
	        next
	      end
        
        # Appending the #WW1fromItaly hashtag
        feed_text = feed_text + " #WW1fromItaly"
        
        twitter_response = nil

        # Case 1: no pictures are posted
        if !box[i].feed_image.present?

	        if feed_text.length <= 140
            twitter_response = client.update(feed_text)
            
            # Verify that twitter_response is not blank
            if !twitter_response.blank? and !twitter_response.id.blank?
	            box[i].update_attribute(:has_been_published_english, 1)

              # If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
              # TODO: we should also trigger an error email to info@ragazzidel99.it
            else
              box[i].update_attribute(:has_been_published_english, -1)
            end
          else
	          # TODO: trigger an error email to info@ragazzidel99.it
	        end

        # Case 2: pictures are posted
        else
        
          # When sending pictures, Twitter creates a http URL that may count towards up to 23 characters
          # As a result, only 140 - 23 = 117 characters are left
	        if feed_text.length <= 117
            twitter_response = client.update_with_media(feed_text, File.new(box[i].feed_image.path))

            # Verify that twitter_response is not blank
            if !twitter_response.blank? and !twitter_response.id.blank?
	            box[i].update_attribute(:has_been_published_english, 1)

              # If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
              # TODO: we should also trigger an error email to info@ragazzidel99.it
            else
              box[i].update_attribute(:has_been_published_english, -1)
            end

          else
	          # TODO: trigger an error email to info@ragazzidel99.it
          end
        
        end

        # TODO: Use rescue for exception handling in case and error occurs. 
        # For instance, when accidentally sending feeds to Twitter with length greater than 140, 
        # the twitter gem produces a fatal error and exits the task immediately with Twitter::Error::Forbidden: Status is over 140 characters. 
			  	
        i = i+1
      
      end # end while loop # 
    end # end initial if statement #   
  end # end send_feeds_english task #
  
end


