Rails.application.routes.draw do
  resources :entries do
    member do
      patch :update_status
    end
  end

  devise_for :users

  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root "home#index", as: :unauthenticated_root
  end

  get "dashboard", to: "dashboard#index"
  get "reports", to: "reports#index"
  get "reports/pdf", to: "reports#pdf", as: :report_pdf

  resources :accounts
  resources :categories
end