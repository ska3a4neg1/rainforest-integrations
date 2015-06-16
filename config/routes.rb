Rails.application.routes.draw do
  resource :events, only: :create
end
