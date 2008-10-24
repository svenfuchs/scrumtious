require File.dirname(__FILE__) + '/../spec_helper'

describe Sprint, '.find_or_initialize_for' do
  before :each do
    Sprint.delete_all
    RemoteInstance.delete_all
    @project = Factory :scrumtious
  end

  it "returns an existing sprint with an existing remote_instance when they match the project and remote_id" do
    @remote_instance = RemoteInstance.create :project => @project, :remote_id => 1
    @sprint = Factory :sprint_1, :remote_instances => [@remote_instance]
    @remote = @project.synchronizer.send(:lighthouse).from_local @sprint
    
    result = Sprint.find_or_initialize_for @project, @remote
    result.should == @sprint
    result.remote_instances.first.should == @remote_instance
  end

  it "returns an existing sprint with a remote_instance when a sprint with the same name exists for the project" do
    @sprint = Factory :sprint_1
    @remote = @project.synchronizer.send(:lighthouse).from_local @sprint
    
    result = Sprint.find_or_initialize_for @project, @remote
    result.should == @sprint
    result.remote_instances.first.should be_instance_of(RemoteInstance)
  end

  it "returns a new sprint with a new remote_instance when no sprint with the same name exists for the project" do
    @sprint = Factory.build :sprint_1
    Sprint.stub!(:new).and_return @sprint
    @remote = @project.synchronizer.send(:lighthouse).from_local @sprint
    
    result = Sprint.find_or_initialize_for @project, @remote
    result.should == @sprint
    result.remote_instances.first.should be_instance_of(RemoteInstance)
    result.remote_instances.first.should be_new_record
  end
end

# describe Sprint, '#tickets' do
#   include TicketScenarios
#
#   before :each do
#     bunch_of_tickets!
#   end
#
#   it "returns all tickets that belong to the sprint" do
#     @sprint_1.tickets.include?(@ticket_2).should be_true
#   end
#
#   it "returns all tickets that ever belong to the sprint" do
#     @sprint_1.tickets.include?(@ticket_1).should be_true
#   end
#
#   it "does not return tickets that never belonged to the sprint" do
#     @sprint_1.tickets.include?(@ticket_5).should be_false
#   end
#
#   it "reverts tickets back to the last version from when they belonged to the sprint (sprint 1)" do
#     @sprint_1.tickets.detect{|t| t.id == @ticket_1.id }.version.should == 4
#   end
#
#   it "reverts tickets back to the last version from when they belonged to the sprint (sprint 1)" do
#     @sprint_2.tickets.detect{|t| t.id == @ticket_1.id }.version.should == 5
#   end
# end
#
# describe Sprint, '#push!' do
#   include TicketScenarios
#
#   before do
#     @project = Factory :scrumtious
#     @sprint = Factory :sprint_1
#     @sprint.stub!(:projects).and_return [@project]
#   end
#
#   it "delegates to the projects synchronizer" do
#     @project.synchronizer.should_receive(:push!)
#     @sprint.push!
#   end
# end