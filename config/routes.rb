ActionController::Routing::Routes.draw do |map|
  map.resources :releases
  map.resources :projects
  map.resources :sprints
  
  map.new_project_release 'projects/:project_id/releases/new', :controller => 'releases', :action => 'new'
  map.new_project_ticket 'projects/:project_id/tickets/new', :controller => 'tickets', :action => 'new'
  
  map.resources :components
  map.resources :categories
  map.resources :synchronizers
  map.resources :schedule, :path_prefix => "projects/:project_id"
  
  map.resources :activities
  map.tickets_update_all "/tickets", :controller => 'tickets', :action => 'update_all', :conditions => {:method => :put}
  map.resources :tickets
  
  map.login "sessions", :controller => 'sessions', :action => 'create', :conditions => {:method => :post}

  map.root :controller => 'projects'
end
