Rails.application.routes.draw do
  resources :domains
  get 'domains/:id/pages', to: "domains#pages"

  root :to => "domains#index"
end
