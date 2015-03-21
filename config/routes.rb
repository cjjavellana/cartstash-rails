Rails.application.routes.draw do

  root to: 'main#index'

  devise_for :users

end
