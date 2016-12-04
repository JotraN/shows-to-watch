Rails.application.routes.draw do
  root "shows#in_progress"

  devise_for :users
  resources :users, only: [:index, :update, :destroy]
  get "/users/request_admin", to: "users#request_admin", as: "user_request_admin"

  get "/shows/abandoned", to: "shows#abandoned", as: "shows_abandoned"
  get "/shows/completed", to: "shows#completed", as: "shows_completed"
  get "/shows/in_progress", to: "shows#in_progress", as: "shows_in_progress"
  resources :shows do
    get "search", on: :member
    patch "update_tvdb", on: :member
  end
end
