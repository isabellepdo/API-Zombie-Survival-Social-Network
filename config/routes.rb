Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  # Route for creating users
  resources :users, only: [:create]
end
