Rails.application.routes.draw do
  resources :shows do
    get "search", on: :member
  end
end
