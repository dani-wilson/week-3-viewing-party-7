Rails.application.routes.draw do
  root 'welcome#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/users/:id/movies', to: 'movies#index', as: 'movies'
  get '/users/:user_id/movies/:id', to: 'movies#show', as: 'movie'
  get '/users/:user_id/movies/:id/viewing_party', to: 'viewing_parties#new'
  post '/users/:user_id/movies/:id/viewing_party', to: 'viewing_parties#create'

  resources :users, only: :show

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
