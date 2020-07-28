Rails.application.routes.draw do
  get 'goods/search'
  # resources :tweets
  # root  'products#index'
  get 'index' => 'products#index'
  root to: 'goods#search'

end
