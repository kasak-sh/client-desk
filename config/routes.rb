Rails.application.routes.draw do
  # Admin routes (not account-scoped)
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :accounts do
      member do
        patch :upload_logo
      end
    end
    resources :users, except: [:show] do
      member do
        patch :reset_password
      end
    end
  end

  # Account-scoped routes
  scope ':account_slug' do
    # Authentication
    get 'login', to: 'accounts/sessions#new', as: :account_login
    post 'login', to: 'accounts/sessions#create'
    delete 'logout', to: 'accounts/sessions#destroy', as: :account_logout

    # Dashboard
    get 'dashboard', to: 'accounts/dashboard#index', as: :account_dashboard

    # Resources
    resources :clients, controller: 'accounts/clients'
    resources :bookings, controller: 'accounts/bookings'
  end

  # Health check and PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root route - can show a list of accounts or redirect to admin
  root "welcome#index"
end
