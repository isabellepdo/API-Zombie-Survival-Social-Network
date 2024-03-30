Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  # Rota para criação de usuários
  resources :users, only: [:create]
end
