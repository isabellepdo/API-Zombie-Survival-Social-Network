Rails.application.routes.draw do
	devise_for :users, controllers: { registrations: 'registrations' }

	# Route for creating users
	#resources :users, only: [:create]

	# Route for users
	resources :users do
		member do
			post 'create'
			get 'update_location'
		end
	end
	post '/report_user', to: 'users#report_user'

	# Routes for inventory
	get '/add_item', to: 'inventory_movement#add_item'
  get '/remove_item', to: 'inventory_movement#remove_item'
	get '/barter', to: 'inventory_movement#barter'

	# Routes for reports
	get '/percentage_of_healthy_users', to: 'reports#percentage_of_healthy_users'
  get '/percentage_of_non_infected_users', to: 'reports#percentage_of_non_infected_users'
	get '/quantity_of_each_type_of_item_per_user', to: 'reports#quantity_of_each_type_of_item_per_user'
  get '/number_of_points_lost_by_infected_users', to: 'reports#number_of_points_lost_by_infected_users'
end
