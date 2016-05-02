Rails.application.routes.draw do
  get 'main/index'
  resources :roles

  devise_for :staffers, controllers: { sessions: "sessions" }

  # TODO, fixme: devise的路由与次路由冲突，考虑假如名空间
  # resources :staffers, only: [ :show, :destroy ]

  root "mis/store_chains#index"

  namespace :mis do
    resources :staffers, except:[:destroy] do
      member do
        post :toggle
      end
      resource :agent_payments, only: [:create, :show]
    end
    resources :stores, only: [:index, :update, :new, :show, :create] do
      resource :financial_infos, only: [:new, :create, :show, :edit]
      resource :internet_infos , only: [:new, :create, :show, :edit]
      resource :ficilities_infos, only: [:new, :create, :show, :edit, :destroy] do
        collection do
          post 'create_station',  'edit_station'
        end
      end
      resource :account_infos, only: [:new, :create, :show, :edit] do
        collection do
          post 'add_info_category'
        end
      end
      resources :store_staffs
    end
    resources :store_chains do
      collection do
        get :city_code, :regions_code
      end
    end
    resources :categories, only: [:index, :new, :create, :update]
    resources :softwares, only: [:index, :create, :new, :show]
    resources :messages, only: [:index, :create, :new, :show]
    resources :ca_stations, only: [:create, :destroy]
    resources :info_categories do
      member do
          get :new_subtype
      end
    end
    resources :agents
    resources :vehicles, only: [:index]
    resources :vehicle_brands, only: [:create, :update]
    resources :vehicle_manufacturers, only: [:create, :update]
    resources :vehicle_series, only: [:index, :create, :show, :update]
    resources :vehicle_models, only: [:create, :update]
  end

  namespace :api do
    resources :store_chains, only: [:show, :index, :update, :create]
    resources :roles, only: [:index, :create, :update, :show, :destroy]
  end
end
