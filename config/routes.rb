require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :v1 do
    resources :accounts
    resources :boletos do
      collection do
        get :conciliation
      end
      member do
        get :register
      end
    end
  end
end
