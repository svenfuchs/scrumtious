require File.dirname(__FILE__) + '/../spec_helper'

describe Sprint, '#tickets' do
  include TicketScenarios
  
  before :each do
    bunch_of_tickets!
  end
  
  it "returns all tickets that belong to the sprint" do
    @sprint_1.tickets.include?(@ticket_2).should be_true
  end
  
  it "returns all tickets that ever belong to the sprint" do
    @sprint_1.tickets.include?(@ticket_1).should be_true
  end
  
  it "does not return tickets that never belonged to the sprint" do
    @sprint_1.tickets.include?(@ticket_5).should be_false
  end
  
  it "reverts tickets back to the last version from when they belonged to the sprint (sprint 1)" do
    @sprint_1.tickets.detect{|t| t.id == @ticket_1.id }.version.should == 4
  end
  
  it "reverts tickets back to the last version from when they belonged to the sprint (sprint 1)" do
    @sprint_2.tickets.detect{|t| t.id == @ticket_1.id }.version.should == 5
  end
end

describe Sprint, '#push!' do
  include TicketScenarios
  
  before do
    @project = Factory :scrumtious
    @sprint = Factory :sprint_1
    @sprint.stub!(:projects).and_return [@project]
  end
  
  it "delegates to the projects synchronizer" do
    @project.synchronizer.should_receive(:push!)
    @sprint.push!
  end
end