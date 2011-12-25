Emonweb::Application.routes.draw do

  get "graphs/realtime"

  get "graphs/raw"

  get "graphs/bar"

  match "widgets/dial/"

  namespace :api do
    namespace :v1 do
      resources :inputs do
        collection do
          post 'api'
        end
      end
      resources :data_stores, :only => [:index]
    end
  end

  match 'api'  => 'api/v1/inputs#api', :via => :post
  match 'api'  => 'api/v1/data_stores#index', :via => :get
  match 'home' => 'home#index'

  root :to => 'api/v1/inputs#index'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :token_authentications, :only => [:create, :destroy]
  resources :feeds, :only => [:index, :show]

end
