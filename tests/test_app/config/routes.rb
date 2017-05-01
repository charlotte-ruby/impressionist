TestApp::Application.routes.draw do
  
  resources :posts, :widgets, :dummy
  resources :articles do
    member do
      get :additional_fields
    end
  end
  get 'profiles/[:id]' => 'profiles#show'
end
