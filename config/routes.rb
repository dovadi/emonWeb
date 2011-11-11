Emonweb::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :inputs do
        collection do
          post 'api'
        end
      end
    end
  end

  match 'api'  => 'api/v1/inputs#api', :via => :post
  match 'home' => 'home#index'

  root :to => 'api/v1/inputs#index'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :token_authentications, :only => [:create, :destroy]
  resources :feeds, :only => [:index, :show]

end
