Rails.application.routes.draw do
  #post 'articles/create'
  #get 'articles/new'
  #get 'welcome/index'
  resources :articles
  resources :articles do
    resources :comments
  end
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
