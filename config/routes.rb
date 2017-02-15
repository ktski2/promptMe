Rails.application.routes.draw do
  get 'sessions/new'

  # main page of WriteIt
  root :to => "home#index"

  # add a new user page
  get 'users/new'

  get 'home/index'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  # sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :posts
  resources :users
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
