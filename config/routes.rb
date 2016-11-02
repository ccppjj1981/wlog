Rails.application.routes.draw do
  #post 'articles/create'
  #get 'articles/new'
  #get 'welcome/index'
  resources :articles
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
