Rails.application.routes.draw do 
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'root#root'

  resources :projects, only: [:show, :new, :create, :edit, :update]
  resources :reviews, only: [:show, :create, :edit, :update]
  resources :ratings, only: [:create]
  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:show]

  get '/reviews/new/:project_id', to: 'reviews#new', as: 'new_review'
  get '/ratings/new/:review_id', to: 'ratings#new', as: 'new_rating'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
