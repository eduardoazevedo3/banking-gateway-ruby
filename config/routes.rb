require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    resources :accounts
    resources :boletos
  end
end
