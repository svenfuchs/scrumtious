require File.dirname(__FILE__) + '/../spec_helper'

describe Project, '#synchronizer' do
  before :each do
    @project = Factory :scrumtious
  end
  
  it "returns a synchronizer instance with project set" do
    @project.synchronizer.project.should == @project
  end
end