require File.dirname(__FILE__) + '/../spec_helper'
require 'synchronizer'

describe Lighthouse::Project, ".from_local" do
  it "creates an instance from a local Project instance" do
    project = Factory :scrumtious
    attributes = { 
      # :id => project.remote_id, 
      :name => project.name, 
      :body => project.body 
    }
    Lighthouse::Project.attributes_from_local(project).should == attributes
  end
end