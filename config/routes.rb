Rails.application.routes.draw do
  root "properties#index"

  resources :reservations, only: [:index, :show, :destroy]
  resources :properties do
    get :reservations
  end
  post 'properties/:id', to: 'properties#reserve'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
