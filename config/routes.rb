Rails.application.routes.draw do
  devise_for :users
  root 'shows#index'
  resources :shows do
    get "search", on: :member
  end
end
