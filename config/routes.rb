Rails.application.routes.draw do
  root 'projects#index'

  resources :projects, only: [:index, :show]
  resources :reviews, only: [:create, :new]
end
