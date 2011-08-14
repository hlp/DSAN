Dsan::Application.routes.draw do

  #get "image_wall/index"

  #get "password_reset/new"
  #get "password_reset/create"

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :ds_modules

  match '/create_module', :to => 'ds_modules#new'

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/signup', :to => 'users#new'

  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'

  match '/reset_password', :to => 'password_reset#new'
  match '/reset_password_create', :to => 'password_reset#create'

  match '/images', :to => 'image_wall#index'

  root :to => 'pages#home'

  get "pages/home"
  get "pages/contact"
  get "pages/about"
  get "pages/help"

end
