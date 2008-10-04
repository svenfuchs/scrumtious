ActionController::Routing::Routes.draw do |map|
  map.resources :releases
  map.resources :projects
  map.resources :sprints
  map.resources :components
  map.resources :tickets
  map.resources :categories
  map.resources :synchronizers
  map.resources :activities
  
  map.login "sessions", :controller => 'sessions', :action => 'create', :method => :post

  map.root :controller => 'projects'
end
