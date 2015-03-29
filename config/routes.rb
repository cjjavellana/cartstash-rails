Rails.application.routes.draw do

  root to: 'preregister#index'

  get 'register', to: 'preregister#new'
  post 'create_user', to: 'preregister#create'

  devise_for :users

end
