Rails.application.routes.draw do
  resources :orders
  resources :products
  post "products/:product_id/add_to_cart", to: "products#add_product_to_cart", as: :add_to_cart
  delete "products/:product_id/remove_to_cart", to: "products#remove_product_to_cart", as: :remove_to_cart
  delete "product/:product_id/remove_all_from_cart", to: "products#remove_all_from_cart", as: :remove_all_from_cart
  resources :products, module: "products" do
    resources :photos
  end

  devise_for :users, controllers: {
    sessions: "user/sessions",
    registrations: "user/registrations"
  }
  namespace :user do
    get "about", to: "user#about", as: :about
    resources :addresses
    resources :carts
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "main#dashboard"
end
