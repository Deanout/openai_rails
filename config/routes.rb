Rails.application.routes.draw do
  post 'ai_request', to: 'pages#ai_request'
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
