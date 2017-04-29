Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  # main page of WriteIt
  root :to => "home#index"

  # add a new user page
  get 'users/new'

  get 'home/index'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get  '/new_prompt',  to: 'prompts#new'
  post '/new_prompt',  to: 'prompts#create'
  delete '/remove_prompt/:id',  to: 'prompts#destroy'
  get '/prompts',  to: 'prompts#show'

  # sessions
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  #resources :prompts do
    resources :posts
  #end
  match "/download_post" => "posts#download", via: :get
  match "/random_post" => "home#random_post", via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
