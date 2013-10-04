TestApp::Application.routes.draw do
  resources :articles do
    member do
      get :additional_fields
    end
  end
  
  resources :posts, :widgets, :dummy
end
