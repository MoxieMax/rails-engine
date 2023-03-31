Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  namespace :api do
    namespace :v1 do
      # resources :customers, only: [:index, :show]
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
        # http://localhost:3000/api/v1/merchants/{{merchant_id}}/items
      end
      
      resources :items do
        get "/items/:item_id", to: "items#show"
      end
    end
  end
end
