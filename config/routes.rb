Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'projects#index'

  resources :projects, only: [:index, :show, :new, :create]
  resources :reviews, only: [:show, :create]
  get '/reviews/new/:project_id', to: 'reviews#new', as: 'new_review'
  resources :ratings, only: [:new, :create]
end
