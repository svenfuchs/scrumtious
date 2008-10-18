require File.dirname(__FILE__) + '/../spec_helper'

describe Release, '#push!' do
  before do
    @project = Factory :scrumtious
    @release = Factory :release_001, :project => @project
  end
  
  it "delegates to the projects synchronizer" do
    @project.synchronizer.should_receive(:push!)
    @release.push!
  end
end
