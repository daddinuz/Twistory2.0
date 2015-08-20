TwittwarApp::Application.routes.draw do
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	devise_for :users
	resources :feeds

	get "home/index"

	get "/index"		=> 'home#index'
	get "/profile"	=> 'feeds#profile'
	resources :users, path: '/portal'
	# You can have the root of your site routed with "root"
	devise_scope :user do
		authenticated :user do
			get '/users' => 'devise/registrations#edit'
			root 'feeds#index', as: :authenticated_root
		end
		
		unauthenticated do
			get '/users' => 'devise/registrations#new'
			root 'home#index', as: :unauthenticated_root
		end
	end
end
