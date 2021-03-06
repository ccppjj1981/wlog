Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, controllers: {
        sessions: 'users/sessions'
  }
  resources :blogs do
    resources :likes, only: [:index, :create, :destroy]
  end
  resources :welcome
  resources :posts
  resources :posts , except: [:show,:new] do
    member do
      get :srj_convert
    end
    collection do
        post :convert_markdown
    end
    resources :comments do
      collection do
        get :refresh
      end
    end
  end
  namespace :admin do
    resources :posts do
      member do
        get :srj_convert
      end
      collection do
          post :convert_markdown
      end
      resources :comments do
        collection do
          get :refresh
        end
      end
    end
    resources :sessions, :only=>[:new, :create, :destroy]
    root "dashboard#index"
  end
  root 'posts#index'
  get '/about' => 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
