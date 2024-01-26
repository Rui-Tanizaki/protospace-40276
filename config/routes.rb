Rails.application.routes.draw do
  devise_for :users
  resources :prototypes do
    resources :comments,only: :create
  end
  resources :users ,only: :show
  
  root to: "prototypes#index"
end
