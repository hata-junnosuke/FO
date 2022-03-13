Rails.application.routes.draw do
  resources :products, only: %i[index new create]
end
