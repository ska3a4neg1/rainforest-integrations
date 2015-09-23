Rails.application.routes.draw do
  resources :events, only: :create
  resources :integrations, only: %i(index show)

  if Rails.env.development?
    resources :events, only: :index
  end
end
