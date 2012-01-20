TestApp::Application.routes.draw do
  resources :articles, :posts, :widgets

  match '/(:page)' => "welcome#static"
end
