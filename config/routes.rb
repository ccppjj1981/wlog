Rails.application.routes.draw do
  #post 'articles/create'
  #get 'articles/new'
  #get 'welcome/index'

    #resources :articles
    #resources :articles do
    #resources :comments
    #end

  resources :posts
  resources :posts , except: [:show] do
    member do
      get :srj_convert
    end
    collection do
        post :preview
    end
    resources :comments do
      collection do
        get :refresh
      end
    end
  end

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
