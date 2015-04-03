Rails.application.routes.draw do

  root to: 'prelaunch#index'

  devise_for :users, :controllers => { :registrations => 'registrations' }
  devise_scope :user do
    get '/users/registrations/confirm_account' => 'registrations#confirm_account'
    get '/users/registrations/membership' => 'registrations#membership'
    post '/users/registrations/membership' => 'registrations#process_membership_fee'
  end

  get '/shop/browse', to: 'main#index'


end
