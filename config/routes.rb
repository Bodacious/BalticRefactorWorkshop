Rails.application.routes.draw do
  resources :products, except: [:show]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect('/products')
end
