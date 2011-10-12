Emonweb::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :inputs
    end
  end

  match 'api' => 'api/v1/inputs#create', :via => :post

  root :to => "home#index"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  resources :token_authentications, :only => [:create, :destroy]

end
