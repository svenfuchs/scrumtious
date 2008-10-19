Scenario.define :two_sprints do
  attrs = { 
    :project => @project,
    :release => @release_1,
    :remote_id => 3, 
    :name => '#1', 
    :body => 'Sprint #1 description' 
  }
  @sprint_1 = Sprint.create attrs.update(:project => @project)

  attrs = { 
    :project => @project,
    :release => @release_1,
    :remote_id => 4, 
    :name => '#2', 
    :body => 'Sprint #2 description' 
  }
  @sprint_2 = Sprint.create attrs.update(:project => @project)
  
  @sprints = @sprint_1, @sprint_2
end