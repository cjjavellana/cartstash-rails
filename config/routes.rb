Rails.application.routes.draw do

  root to: 'preregister#index'
  get 'register', to: 'preregister#show'

  devise_for :users

end
