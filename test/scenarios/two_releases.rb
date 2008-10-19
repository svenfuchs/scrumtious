Scenario.define :two_releases do
  attrs = { :remote_id => 1, :name => '0.0.1', :body => 'Release 0.0.1 description' }
  @release_1 = Release.create attrs.update(:project => @project)

  attrs = { :remote_id => 2, :name => '0.0.2', :body => 'Release 0.0.2 description' }
  @release_2 = Release.create attrs.update(:project => @project)
  
  @releases = @release_1, @release_2
end