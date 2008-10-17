require File.dirname(__FILE__) + '/../spec_helper'

describe Sprint, '#tickets' do
  before :each do
    @sprint = milestones :sprint_1
    @ticket_1 = tickets(:ticket_1)
    @ticket_2 = tickets(:ticket_2)
    @ticket_5 = tickets(:ticket_5)
  end
  
  it "returns all tickets that belong to the sprint" do
    @sprint.tickets.include?(@ticket_2).should be_true
  end
  
  it "returns all tickets that ever belong to the sprint" do
    @sprint.tickets.include?(@ticket_1).should be_true
  end
  
  it "does not return tickets that never belonged to the sprint" do
    @sprint.tickets.include?(@ticket_5).should be_false
  end
  
  it "reverts tickets back to the last version from when they belonged to the sprint" do
    @sprint.tickets.detect{|t| t.id == @ticket_1.id }.version.should == 4
  end
end
