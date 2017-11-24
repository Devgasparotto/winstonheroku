Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #Root Page
  root 'welcome#index'

  get "/testPDF/", to: "welcome#testPDF"

end
