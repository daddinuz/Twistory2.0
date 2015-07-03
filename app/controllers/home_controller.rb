class HomeController < ApplicationController
	def index
		@feeds = Feed.all
	end
end
