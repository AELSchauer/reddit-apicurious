Rails.application.routes.draw do

  root to: 'home#index'

  get '/auth/reddit/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :dashboard, only: :index

  get '/r/:title' => "subreddits#show", :as => "subreddit"
  get '/user/:username' => "view_users#show", :as => "view_user"
end
