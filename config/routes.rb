Rails.application.routes.draw do

  get "experience/index"
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "chat_room", to: "chats#room"
  mount ActionCable.server => '/cable'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  resources :articles do
    resources :sections, only: [:destroy]
  end

  # Documents / file uploads
  resources :documents, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  # Root page: home#index (landing page with quick links)
  root "home#index"
  get "exp" => "experience#index", as: :exp
  resources :locations, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :cars, only: [:index, :show, :create, :update, :destroy]
    end
  end

   resources :urls, only: [:create]

  get '/:short_code', to: 'urls#redirect'
end
