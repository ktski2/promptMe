Rails.application.routes.draw do
  # main page of WriteIt
  root :to => "home#index"

  # add a new user page
  get 'users/new'

  get 'home/index'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  resources :posts
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
