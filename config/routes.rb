Rails.application.routes.draw do
  resources :posts
  resources :welcome
  resources :posts , except: [:show] do
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
    resources :posts
    resources :sessions, :only=>[:new, :create, :destroy]
    root 'dashboard#index'
  end
  root 'blogs#index'
  get '/about' => 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
