Rails.application.routes.draw do
  resources :events, only: :create
  resources :integrations, only: %i(index show)
end
