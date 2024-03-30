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
end
