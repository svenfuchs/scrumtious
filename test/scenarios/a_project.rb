Scenario.define :a_project do
  attrs = { :remote_id => 1, 
            :name => 'Scrumtious', 
            :lighthouse_account => 'artweb', 
            :lighthouse_token => 'lighthouse_token' }
  @project = Project.create attrs
end