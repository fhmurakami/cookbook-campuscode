Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'recipes#index'

  resources :recipes, only: %i[index show new create edit update destroy] do
    get 'all', on: :collection
    get 'featured', to: 'recipes#featured'
    post 'add_to_list', to: 'recipes#add_to_list', as: 'to_list'
  end
  resources :recipe_types, only: %i[show new create edit update destroy]
  resources :cuisines, only: %i[show new create edit update destroy]
  resources :users, only: %i[show new create edit update destroy]
  resources :recipe_lists, only: %i[show new create edit update destroy] do
    delete :delete_recipe, to: 'recipe_lists#delete_recipe'
  end
  get 'search', to: 'recipes#search' 

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :recipes, only: %i[show create update destroy] do
        get 'all', on: :collection
      end

      resources :cuisines, only: %i[index]
      resources :recipe_types, only: %i[index]
      resources :users, only: %i[show create update destroy]
      resources :sessions, only: %i[create destroy]
    end
  end
end
