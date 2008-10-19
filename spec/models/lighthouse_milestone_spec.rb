require File.dirname(__FILE__) + '/../spec_helper'
require 'synchronizer'

describe Lighthouse::Milestone, ".attributes_from_local" do
  it "maps local attributes to remote attributes" do
    milestone = Factory :release_001
    attributes = { :id => milestone.remote_id, :title => milestone.name, :body => milestone.body }
    Lighthouse::Milestone.attributes_from_local(milestone).should == attributes
  end
end

describe Lighthouse::Milestone, '#attributes_for_local' do
  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
    attributes = { :id => 1, :title => 'Release 0.0.1', :due_on => Date.parse('2008-10-01') }
    @remote_milestone = Lighthouse::Milestone.new attributes
  end
  
  it "maps remote attributes to local attributes (given a release milestone)" do
    expected = { :remote_id => @remote_milestone.id, :name => '0.0.1', :end_at => Date.parse('2008-10-02') }
    @remote_milestone.attributes_for_local.should == expected
  end
  
  it "maps remote attributes to local attributes (given a sprint milestone)" do
    @remote_milestone.title = 'Sprint #1'
    expected = { :remote_id => @remote_milestone.id, :name => '#1', :end_at => Date.parse('2008-10-02') }
    @remote_milestone.attributes_for_local.should == expected
  end
end

describe Lighthouse::Milestone, '#update_attributes!' do
  include HttpMockHelper
  
  before :each do
    @project = Factory :scrumtious
    @release = Factory :release_001
    @lighthouse = Synchronizer::Lighthouse.new @project

    @remote_milestone = @lighthouse.from_local @release
    @attributes = {:name => '0.0.2', :body => 'updated body'}

    mock_put_to_milestone @project, @release.remote_id, @remote_milestone.to_xml
  end
  
  def act!
    @remote_milestone.update_attributes! @attributes
  end
  
  it "sets the attributes to the remote milestone" do
    @remote_milestone.should_receive(:'name=').with @attributes[:name]
    @remote_milestone.should_receive(:'body=').with @attributes[:body]
    act!
  end
  
  it "saves the remote milestone" do
    @remote_milestone.should_receive(:save)
    act!
  end
  
  it "PUTs the xml data to the remote milestone url" do
    act!
    should_have_put_to_milestone @project, @release.remote_id, @remote_milestone.to_xml
  end
end
