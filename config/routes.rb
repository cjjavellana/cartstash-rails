Rails.application.routes.draw do

  root to: 'prelaunch#index'

  devise_for :users, :controllers => { :registrations => 'registrations' }

end
