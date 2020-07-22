Rails.application.routes.draw do
  # resources :tweets
  root  'products#index'
  get 'index' => 'products#index'
end
