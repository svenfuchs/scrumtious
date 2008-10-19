require File.dirname(__FILE__) + '/../spec_helper'
require 'synchronizer'

describe Lighthouse::Ticket, ".attributes_from_local" do
  it "creates an instance from a local Ticket instance" do
    ticket = Factory :ticket, :project => Factory(:scrumtious), :sprint => Factory(:sprint_1)
    attributes = { 
      :id => ticket.remote_id, 
      :number => ticket.remote_id, 
      :title => ticket.title, 
      :body => ticket.body,
      :closed => 0,
      :state => 'new',
      :milestone_id => ticket.sprint.remote_id,
      :assigned_user_id => ticket.user.remote_id
    }
    Lighthouse::Ticket.attributes_from_local(ticket).should == attributes
  end
end

describe Lighthouse::Ticket, '#attributes_for_local' do
  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
    attributes = { 
      :id => 1, 
      :title => 'Ticket title', 
      :state => 'new',
      :closed => 0,
      :milestone_id => 1,
      :assigned_user_id => 1
    }
    @remote_ticket = Lighthouse::Ticket.new attributes
    
    User.stub!(:find_by_remote_id).with(1).and_return mock('user', :id => 2)
    Milestone.stub!(:find_by_remote_id).with(1).and_return mock('milestone', :id => 2, :class => Milestone)
  end
  
  it "maps remote attributes to local attributes" do
    expected = { 
      :remote_id => @remote_ticket.id, 
      :title => 'Ticket title', 
      :state => 'new',
      :closed => 0,
      :milestone_id => 2,
      :user_id => 2
    }
    @remote_ticket.attributes_for_local.should == expected
  end
end

describe Lighthouse::Ticket, '#update_attributes!' do
  include HttpMockHelper
  
  before :each do
    @project = Factory :scrumtious
    @ticket = Factory :ticket, :project => @project, :sprint => Factory(:sprint_1)
    @lighthouse = Synchronizer::Lighthouse.new @project

    @remote_ticket = @lighthouse.from_local @ticket
    @attributes = {:name => '0.0.2', :body => 'updated body'}

    mock_put_to_ticket @project, @ticket.remote_id, @remote_ticket.to_xml
  end
  
  def act!
    @remote_ticket.update_attributes! @attributes
  end
  
  it "sets the attributes to the remote ticket" do
    @remote_ticket.should_receive(:'name=').with @attributes[:name]
    @remote_ticket.should_receive(:'body=').with @attributes[:body]
    act!
  end
  
  it "saves the remote ticket" do
    @remote_ticket.should_receive(:save)
    act!
  end
  
  it "PUTs the xml data to the remote ticket url" do
    act!
    should_have_put_to_ticket @project, @ticket.remote_id, @remote_ticket.to_xml
  end
end
