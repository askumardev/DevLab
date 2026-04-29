namespace :api do
  namespace :v1 do
    resources :cars
    resources :articles do
      resources :comments, only: [:index, :create, :destroy]
    end
  end
end
