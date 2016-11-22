Rails.application.routes.draw do
  root "shows#index"

  devise_for :users
  resources :users, only: [:index, :update, :destroy]
  get "/users/request_admin", to: "users#request_admin", as: "user_request_admin"

  get "/shows/abandoned", to: "shows#abandoned", as: "shows_abandoned"
  resources :shows do
    get "search", on: :member
    patch "update_tvdb", on: :member
  end
end
