Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'projects#index'

  resources :projects, only: [:index, :show, :new, :create, :edit, :update]
  resources :reviews, only: [:show, :create, :edit, :update]
  resources :ratings, only: [:create]
  get '/reviews/new/:project_id', to: 'reviews#new', as: 'new_review'
  get '/ratings/new/:review_id', to: 'ratings#new', as: 'new_rating'
end
