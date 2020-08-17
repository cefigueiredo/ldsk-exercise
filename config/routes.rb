Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      get '/users/:username', to: 'users#show'
      put '/users/:username', to: 'users#update'
      patch '/users/:username', to: 'users#update'
      delete '/users/:username', to: 'users#destroy'

      post '/login', to: 'login#create'
    end
  end
end
