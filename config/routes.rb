Rails.application.routes.draw do
  root "pages#home"

  resources :articles do
    resources :bookmarks, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create]
    member do
      post "like"
      delete :delete_image_attachment
    end
  end

  get "signup", to: "users#new"
  resources :users, except: :new do
    resources :bookmarks, only: [:index], shallow: true
  end

  get "/login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :categories

  mount ActionCable.server => "/cable"

  get "/chat", to: "chatrooms#show"
  resources :messages, only: :create

  get "search", to: "articles#search"
end
