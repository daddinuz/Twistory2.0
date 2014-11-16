require 'google/api_client'
require 'json'

class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
	
  # error message for feeds not belonging to a user
  def error_message 
    flash.now[:notice] = "Non sei il possessore di questo feed e non detieni i privilegi per alterarlo!" 			
    render "show"
  end
  #  end #
		
  # GET /feeds
  def index
    @feeds = Feed.all
    @feed = Feed.new
  end
  # index end #

  # GET /feeds
  def profile
    @feeds = Feed.all
    @feed = Feed.new
  end
  # profile end # 
  
  # GET /feeds/1
  def show
  end
  # show end #

  # GET /feeds/new
  def new
    @feed = Feed.new
  end
  # new end #

  # GET /feeds/1/edit
  def edit

    # Show CET/CEST time to the user starting from the UTC time in the Database
    # TODO: have a better solution (see create action)
    @feed.date = @feed.date + 1.hour 
    
    if @feed.user_id != current_user.id
      error_message 
    elsif @feed.has_been_published == true
      flash[:notice] = "Non puoi modificare feeds già pubblicati"
      render "show"
    end

  end 
  # edit end #

  # POST /feeds
  def create
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id

    # Here comes a quick dirty ugly workaround. Remember that:

    # --- The server (both application and Database) uses and stores time in UTC (Universal Time)
    # --- Feed dates are going to be entered by the user in the form
    # --- S/he will enter the time values according to Italian timezone
    # --- Currently (winter 2014), Italian time follows CET (Central European Time)
    # --- CET is 1 hours beyond UTC
    # --- Important: in summer, Italian time will follow CEST (Central European Summer Time)
    # --- CET is 2 hour beyond UTC
 
    # So, for now, the dirty ugly workaround relies on converting the user-input CET value to UTC 
    # using a simple 1 hour subtraction from the DateTime object.
    # This will have be be modified with a 2 hour subtraction when daylight saving time changes
    # TODO: have a better solution

    @feed.date = @feed.date - 1.hour 	

    # Translate from the original Italian text to English via Google Translate APIs in production mode
    if Rails.env.production?
      feed_text_english = translate_feed(@feed.feed_text) 
      
      if !(feed_text_english.blank?) 
        if @feed.feed_image.blank?
          if feed_text_english.size > 124
            feed_text_english = feed_text_english.slice(0, 121)
            feed_text_english += '...'
            flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
          end
        elsif feed_text_english.size > 101
          feed_text_english = feed_text_english.slice(0, 98)
          feed_text_english += '...'
          flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
        else
          flash[:notice] = 'Entrambi i feeds sono stati aggiornati con successo'
        end       
      end
             
      @feed.feed_text_english = feed_text_english
    else
      @feed.feed_text_english = 'Hi there! Write here the english traslation'
    end
    
    respond_to do |format|
      if @feed.save
        if feed_text_english.blank?
          flash[:notice] = 'La versione Italiana del feed è stata creata con successo'
        else
          flash[:notice] = 'Entrambe le versioni del feed sono state create con successo'
        end
        format.html { render action: 'edit' }
      else
        format.html { render action: 'new' }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
    
  end
  # create end #

  # PATCH/PUT /feeds/1
  def update
    if @feed.user_id == current_user.id
            
      respond_to do |format|
      
        if @feed.update(feed_params)

          # Convert the CET/CEST time (inserted by the user) in UTC time (expected by the Database)
    	    # TODO: have a better solution (see create action)
    	    @feed.date = @feed.date - 1.hour
    	    
    	    if @feed.feed_text_english.blank?                        
            flash[:notice] = 'Il feed Italiano è stato aggiornato con successo'  
          else
            if @feed.feed_image.blank?
              if @feed.feed_text_english.size > 124
                @feed.feed_text_english = @feed.feed_text_english.slice(0, 121)
                @feed.feed_text_english += '...'
                flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
              end
            elsif @feed.feed_text_english.size > 101
              @feed.feed_text_english = @feed.feed_text_english.slice(0, 98)
              @feed.feed_text_english += '...'
              flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
            else
              flash[:notice] = 'Entrambi i feeds sono stati aggiornati con successo'
            end 
          end
          
          @feed.save

          format.html { redirect_to action: 'index' }
        else
          format.html { render action: 'edit' }
          format.json { render json: @feed.errors, status: :unprocessable_entity }
        end
      end
    else
      error_message
    end
  end	
  # update end #
 
  # DELETE /feeds/1
  def destroy
    if @feed.user_id == current_user.id
      @feed.destroy
      respond_to do |format|
        format.html { redirect_to feeds_url }
        format.json { head :no_content }
      end
    else
      error_message
    end
  end	
  # destroy end #

  private
    # Use Google Translate APIs to translate feed text from the original Italian to English
    def translate_feed(feed_text)
	    google_client = Google::APIClient.new(
		    :application_name => APP_CONFIG['google']['production']['application_name'],
		    :key => APP_CONFIG['google']['production']['key'],
		    :application_version => '1.0.0',
		    :authorization => nil
	    )

	    # Load client secrets from your client_secrets.json
	    # NOT needed for the Google Translate APIs
	    # client_secrets = Google::APIClient::ClientSecrets.load
		
  	  translate = google_client.discovered_api('translate', 'v2')
	    result = google_client.execute(
	      :api_method => translate.translations.list,
	      :parameters => {
	      'format' => 'text',
	      'source' => 'it',
	      'target' => 'en',
	      'q' => feed_text
	      }
	    )
      
	    parsed = JSON.parse(result.data.to_json)
      
	    # Example of data returned 
      # {"translations":[{"translatedText":"This is a pen"}]}'
      
      english_translation = parsed["translations"][0]["translatedText"]
        
      # TODO: return a warning if the translation is over 140 characters (or whatever limit we have)

	    return english_translation
	   
    end
    # translate_feed end #

    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end
    # set_feed end #

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:feed_text, :feed_text_english, :date, :feed_image)
    end
    # feed_params end #
  end
