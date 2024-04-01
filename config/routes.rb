Rails.application.routes.draw do
	devise_for :users, controllers: { registrations: 'registrations' }

	# Route for creating users
	#resources :users, only: [:create]

	# Route for users
	resources :users do
		member do
			post 'create'
			get 'update_location'
			get 'report_user'
		end
	end

	# Routes for inventory
	get '/add_item', to: 'inventory_movement#add_item'
  get '/remove_item', to: 'inventory_movement#remove_item'
	get '/barter', to: 'inventory_movement#barter'
end
