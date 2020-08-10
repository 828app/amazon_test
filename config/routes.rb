Rails.application.routes.draw do
  get 'goods/search'
  # resources :tweets
  # root  'products#index'
  get 'index' => 'products#index'
  get 'tes' => 'products#tes'
  root to: 'goods#search'

end
