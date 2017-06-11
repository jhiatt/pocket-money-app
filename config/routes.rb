Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "pages#index"

  #Calendar events
  get "events", to: 'events#index'
  get "events/new", to: 'events#new'
  post "events", to: 'events#create'
  get "events/:id", to: 'events#edit'
  patch "events/:id", to: 'events#update'

  #One-time expenses
  get "expenses", to: 'expenses#index'
  get "expenses/new", to: 'expenses#new'
  post "expenses", to: 'expenses#create'
  get "expenses/:id", to: 'expenses#edit'
  patch "expenses/:id", to: 'expenses#update'


end
