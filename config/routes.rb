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

  resources :shop, only: [:index, :create, :update, :destroy]
  resources :delivery_address, only: [:index, :new, :create, :update, :destroy, :show]
  resources :user_profile, only: [:index, :update]

  scope '/shop' do
    resources :checkout, only: [:index, :create]
    get '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    post '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    get '/confirm-order', to: 'checkout#confirm_order'
    post '/confirm-order', to: 'checkout#confirm_order'
    get '/order-receipt', to: 'print_receipt#index'
  end

  get '/server-date', to: 'schedule_picker#current_datetime'

end
