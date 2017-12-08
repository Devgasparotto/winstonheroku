Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #Root Page
  root 'welcome#index'

  get "/testPDF/", to: "welcome#testPDF"
  get "/testEmail/", to: "welcome#testEmail"
  get "/testRoute/", to: "welcome#testRoute"

  get "/CreateSamplePDF/", to:"pdf#CreateSamplePDF"
  get "/CreateAndEmailSamplePDF/", to:"pdf#CreateAndEmailSamplePDF"

end
