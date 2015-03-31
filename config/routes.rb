Rails.application.routes.draw do

  root to: 'prelaunch#index'

  get 'users/registrations/confirm_account', to: 'registrations#confirm_account'
  devise_for :users, :controllers => { :registrations => 'registrations' }

end
