Rails.application.routes.draw do

  root to: 'shop#index'

  devise_for :users,
             :controllers => {
                 :registrations => 'registrations',
                 :sessions => 'sessions',
                 :omniauth_callbacks => 'users/omniauth_callbacks'
             }

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  resources :payment_method, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :shop, only: [:index]
  resources :delivery_address, only: [:index, :new, :create, :edit, :update, :destroy, :show]
  resources :order_history, only: [:index, :show]
  resources :user_profile, only: [:index, :update] do
    collection do
      patch 'update_password'
    end
  end

  scope '/users' do
    get '/ajaxsigninform', to: 'ajax_loginform#new', as: 'ajax_signin'
  end

  scope '/shop' do
    post '/search', to: 'shop#product_search', as: 'product_search'
    get '/categories/:category', to: 'shop#load_by_category', as: 'product_category'
    post '/add2cart', to: 'shop#add2cart', as: 'add2cart'
    put '/updatecart/:q/:sku', to: 'shop#update_cart', as: 'update_cart'
    get '/order_summary', to: 'shop#order_summary', as: 'order_summary'

    resources :checkout, only: [:index, :create]
    get '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    post '/delivery-and-schedule', to: 'checkout#delivery_and_schedule'
    get '/confirm-order', to: 'checkout#confirm_order'
    post '/confirm-order', to: 'checkout#confirm_order'
    get '/order-receipt', to: 'print_receipt#index'
  end

  get '/server-date', to: 'schedule_picker#current_datetime'
  get '/delivery-time/:date', to: 'schedule_picker#available_time', as: 'delivery_time'

  namespace :orders do
    get 'selectdeliveryaddress' => 'select_delivery_address#index'
    post 'selectdeliveryschedule' => 'select_delivery_address#select_schedule'
    post 'adddeliveryaddress' => 'select_delivery_address#add_delivery_address'
  end

  namespace :users do
    post 'deliveryaddress', to: 'delivery_address#create'
    get 'deliveryaddress/:id', to: 'delivery_address#edit'
    patch 'deliveryaddress/:id', to: 'delivery_address#update'
    delete 'deliveryaddress/:id', to: 'delivery_address#destroy'
  end
end
