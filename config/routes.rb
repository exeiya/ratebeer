Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :styles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resources :places, only: [:index, :show]
  post 'places', to:'places#search'

  resources :breweries do
    post 'toggle_activity', on: :member
  end

  resources :users do
    post 'toggle_closed', on: :member
  end

  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
  get 'auth/:provider/callback', to: 'sessions#create_oauth'
end
