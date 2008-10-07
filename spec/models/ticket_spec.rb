require File.dirname(__FILE__) + '/../spec_helper'

describe Ticket, '#update_attributes' do
  before :each do
    @ticket = Ticket.new
    @sprint = mock('sprint', :id => 1, :release_id => 2)
    Sprint.stub!(:find).and_return @sprint
  end

  it "it checks if the sprint is part of a release and if so assigns the ticket to the release as well" do
    @ticket.update_attributes :sprint_id => @sprint.id
    @ticket.release_id.should == @sprint.release_id
  end
end

describe Ticket, 'save_version?' do
  before :each do
    @ticket = Ticket.new
    @yesterday = Time.zone.today.yesterday
    @ticket.stub!(:sprint_running?).and_return true
    @ticket.stub!(:estimated_changed?).and_return true
  end

  it "is true when the sprint is running and estimated hours have changed" do
    @ticket.send(:save_version?).should be_true
  end

  it "is false when estimated hours have not changed (even though sprint running)" do
    @ticket.stub!(:estimated_changed?).and_return false
    @ticket.send(:save_version?).should be_false
  end
  
  it "is false when if the sprint is not running (even though estimated hours changed)" do
    @ticket.stub!(:sprint_running?).and_return false
    @ticket.send(:save_version?).should be_false
  end
end