Rails.application.routes.draw do
  root "shows#in_progress"

  devise_for :users
  resources :users, only: [:index, :update, :destroy]
  get "/users/request_admin", to: "users#request_admin", as: "user_request_admin"
  get "/users/request_token", to: "users#request_token", as: "user_request_token"

  resources :shows do
    collection do 
      get "abandoned", to: "shows#abandoned", as: "abandoned"
      get "completed", to: "shows#completed", as: "completed"
      get "in_progress", to: "shows#in_progress", as: "in_progress"
    end
    get "search", on: :member
    patch "update_tvdb", on: :member
  end

  namespace :api do
    resources :shows do
      collection do 
        get "abandoned", to: "shows#abandoned", as: "shows_abandoned"
        get "completed", to: "shows#completed", as: "shows_completed"
        get "in_progress", to: "shows#in_progress", as: "shows_in_progress"
      end
    end
    resources :users
  end
end
