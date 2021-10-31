Rails.application.routes.draw do
  resources :likes
  resources :follows
  resources :posts
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'main', to: 'users#main', as: 'main'
  post 'main', to: 'users#login'

  get 'register', to: 'users#register', as: 'register'
  post 'register', to: 'users#create_new_user'

  get 'feed', to: 'users#feed', as: 'feed'

  get 'new_post', to: 'users#new_post', as: 'new_post_custom'
  post 'new_post', to: 'users#create_new_post'

  get '/profile/:name', to: 'users#profile', as: 'profile'
  post '/profile/:name', to: 'users#follow_user'
  delete '/profile/:name', to: 'users#unfollow_user'

  post 'like', to: 'users#like_post', as: 'like_manager'
  delete 'like', to: 'users#unlike_post'

end
