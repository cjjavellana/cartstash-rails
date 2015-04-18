Rails.application.routes.draw do

  root to: 'prelaunch#index'

  devise_for :users, :controllers => {:registrations => 'registrations', :sessions => 'sessions'}
  devise_scope :user do
    get '/users/registrations/confirm_account' => 'registrations#confirm_account'
    get '/users/registrations/membership' => 'registrations#membership'
    post '/users/registrations/membership' => 'registrations#credit_card_payment'
    post '/users/registrations/bankdeposit' => 'registrations#bank_deposit'
    get '/users/registrations/complete' => 'registrations#complete'
  end

  resources :shop
  resources :checkout
end
