Rails.application.routes.draw do
  root to: 'home#index'

  get '/auth/reddit/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
