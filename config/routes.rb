ActionController::Routing::Routes.draw do |map|
  map.resources :releases
  map.resources :projects
  map.resources :sprints
  # map.burndown "sprints/:id/burndown.xml", :controller => 'sprints', :action => 'burndown'
  
  map.resources :components
  map.resources :categories
  map.resources :synchronizers
  map.resources :activities
  map.resources :schedule, :path_prefix => "projects/:project_id"
  
  # map.update_schedule "/projects/:project_id/schedule/:day", 
  #                     :controller => 'scheduled_days', :action => 'update', :conditions => {:method => :put}

  map.tickets_update_all "/tickets", :controller => 'tickets', :action => 'update_all', :conditions => {:method => :put}
  map.resources :tickets
  
  map.login "sessions", :controller => 'sessions', :action => 'create', :conditions => {:method => :post}

  map.root :controller => 'projects'
end
