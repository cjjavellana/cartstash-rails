Rails.application.routes.draw do

  root to: 'prelaunch#index'

  devise_for :users, :controllers => { :registrations => 'registrations',
                                       :sessions => 'sessions',
                                       :omniauth_callbacks => 'omni_auth_callbacks' }

  devise_scope :user do
    get '/users/registrations/confirm_account' => 'registrations#confirm_account'
    get '/users/registrations/membership' => 'registrations#membership'
    post '/users/registrations/membership' => 'registrations#credit_card_payment'
    post '/users/registrations/bankdeposit' => 'registrations#bank_deposit'
    get '/users/registrations/complete' => 'registrations#complete'
  end

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :payment_method, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :shop, only: [:index, :create, :update, :destroy]
  resources :delivery_address, only: [:index, :new, :create, :edit, :update, :destroy, :show]
  resources :order_history, only: [:index, :show]
  resources :user_profile, only: [:index, :update] do
    collection do
      patch 'update_password'
    end
  end

  scope '/shop' do
    get '/categories/:category', to: 'shop#index', as: 'product_category'

    resources :checkout, only: [:index, :create]
    get '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    post '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    get '/confirm-order', to: 'checkout#confirm_order'
    post '/confirm-order', to: 'checkout#confirm_order'
    get '/order-receipt', to: 'print_receipt#index'
  end

  get '/server-date', to: 'schedule_picker#current_datetime'

end
