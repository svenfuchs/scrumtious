ActionController::Routing::Routes.draw do |map|
  map.resources :releases
  map.resources :projects
  map.resources :sprints
  map.resources :components
  map.resources :categories
  map.resources :synchronizers
  map.resources :activities

  map.tickets_update_all "/tickets", :controller => 'tickets', :action => 'update_all', :conditions => {:method => :put}
  map.resources :tickets
  
  map.login "sessions", :controller => 'sessions', :action => 'create', :conditions => {:method => :post}

  map.root :controller => 'projects'
end
