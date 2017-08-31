Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # , controllers: {
  #       sessions: 'users/sessions'
  #     }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #delete me
  get "/secret", to: 'events#hidden'

  root to: "pages#index"

  #Calendar events
  get "/events", to: 'events#index'
  get "/events/new", to: 'events#new'
  post "/events", to: 'events#create'
  get "/events/:id", to: 'events#show'
  get "/events/:id/edit", to: 'events#edit'
  patch "/events/:id", to: 'events#update'
  delete "/events/:id", to: 'events#destroy'


  #One-time expenses
  get "/expenses", to: 'expenses#index'
  # get "/expenses/new", to: 'expenses#new'
  post "/expenses", to: 'expenses#create'
  get "/expenses/:id", to: 'expenses#show'
  get "/expenses/:id/edit", to: 'expenses#edit'
  patch "/expenses/:id", to: 'expenses#update'
  delete "/expenses/:id", to: 'expenses#destroy'

  #Tags
  get "/tags", to: 'tags#index'
  get "/tags/new", to: 'tags#new'
  post "/tags", to: 'tags#create'
  get "/tags/:id/edit", to:'tags#create'
  patch "/tags/:id", to: 'tags#update'
  delete "/tags/:id", to: 'tags#destroy'

  #API
  namespace :api do
    namespace :v1 do
      get "/accounts/:id", to: 'accounts#show'
      get "/accounts/:id/edit", to: 'accounts#edit'
      patch "/accounts/:id", to: 'accounts#update'

      get "/users/:id/expenses", to: 'expenses#index'
      post "/expenses", to: 'expenses#create'
      get "/expenses/:id", to: 'expenses#show'
      patch "/expenses/:id/edit", to: 'expenses#edit'
      delete "/expenses/:id/delete", to: 'expenses#destroy'

      post "/tags", to: 'tags#create'
      get "/users/:id/tags", to: 'tags#index'

      get "/users/:id/events", to: 'events#index'
      
      resources :api_users, only: [:new, :create]

    end
  end
end
