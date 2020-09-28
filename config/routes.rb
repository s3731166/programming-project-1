Rails.application.routes.draw do
  resources :plants
  root 'pages#home'
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  get 'get_geocode_results', to: 'plants#geo_results'
  get 'get_spec_results', to: 'plants#spec_results'
  get 'generate_graph', to: 'pages#plant_graph'
  get 'species_fill', to: 'plants#species_fill'
  post 'login', to: 'sessions#create'
  get 'leaderboard', to: 'pages#leaderboard'
  delete 'logout', to: 'sessions#destroy'
  resources :users
end
