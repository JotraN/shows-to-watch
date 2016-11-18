Rails.application.routes.draw do
  root "shows#index"
  devise_for :users
  resources :users, only: [:index, :update, :destroy]
  resources :shows do
    get "search", on: :member
    patch "update_tvdb", on: :member
  end
end
