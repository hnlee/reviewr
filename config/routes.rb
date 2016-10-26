Rails.application.routes.draw do
  root 'projects#index'

  resources :projects, only: [:index, :show, :new, :create]
  resources :reviews, only: [:show, :new, :create]
  resources :ratings, only: [:new, :create]
end
