Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"
  
  resources :users, only: [:index,:show,:edit,:update]
  resources :users do
    member do
      get :followed, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :chats, only: [:show, :create]
  resources :groups do
    get 'join' => 'groups#join'
    delete 'leave' => 'groups#leave'
  end
  get 'search' => 'searches#search'
  post 'book_count' => 'books#count', as: 'book_count'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end