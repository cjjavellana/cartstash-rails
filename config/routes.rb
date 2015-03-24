Rails.application.routes.draw do

  root to: 'preregister#index'

  devise_for :users

end
