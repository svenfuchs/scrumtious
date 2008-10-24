require File.dirname(__FILE__) + '/../spec_helper'

describe Ticket, '#push!' do
  before do
    @project = Factory :scrumtious
    @project.synchronizer.stub! :push_sprint!
    @project.synchronizer.stub! :push!

    @sprint = Factory :sprint_1
    @ticket = Factory :ticket, :sprint => @sprint, :project => @project
  end

  it "delegates to the projects synchronizer" do
    @project.synchronizer.should_receive(:push!).with @ticket
    @ticket.push!
  end

  it "pushes the sprint to the project if no remote instance exists" do
    @project.synchronizer.should_receive(:push!).with @sprint
    @ticket.push!
  end

  it "does not push the sprint to the project if a remote instance exists" do
    @sprint.stub! :remote_instance
    @project.synchronizer.should_receive(:push!).with @sprint
    @ticket.push!
  end
end

describe Ticket do
  include TicketScenarios

  before :each do
    bunch_of_tickets!
    @id = @ticket_1.id
  end

  describe 'find :to => date' do
    it "still works without a :to option" do
      Ticket.find(@id).id.should == @id
    end

    it "returns the latest version at a given day if available (first version)" do
      Ticket.find(@id, :to => Date.parse('2008-10-01')).version.should == 1
    end

    it "returns the latest version at a given day if available (second version)" do
      Ticket.find(@id, :to => Date.parse('2008-10-02')).version.should == 2
    end

    it "returns the latest version at a given day if available (third version)" do
      Ticket.find(@id, :to => Date.parse('2008-10-03')).version.should == 3
    end
  end

  describe 'find :from => date, :to => date' do
    it "still works without a :from and :to option" do
      Ticket.find(@id).id.should == @id
    end

    it "returns the latest version at a given day if available (first version)" do
      Ticket.find(@id, :from => Date.parse('2008-10-01'), :to => Date.parse('2008-10-01')).version.should == 1
    end

    it "returns the latest version at a given day if available (second version)" do
      Ticket.find(@id, :from => Date.parse('2008-10-01'), :to => Date.parse('2008-10-02')).version.should == 2
    end

    it "returns the latest version at a given day if available (third version)" do
      Ticket.find(@id, :from => Date.parse('2008-10-02'), :to => Date.parse('2008-10-03')).version.should == 3
    end
  end

  describe Ticket, 'save_version?' do
    before :each do
      @ticket = Ticket.new
      @yesterday = Time.zone.today.yesterday
      @ticket.stub!(:sprint_running?).and_return false
      @ticket.stub!(:estimated_changed?).and_return false
      @ticket.stub!(:sprint_id_changed?).and_return false
    end

    it "is true when the sprint is running and estimated hours have changed" do
      @ticket.stub!(:sprint_running?).and_return true
      @ticket.stub!(:estimated_changed?).and_return true
      @ticket.send(:save_version?).should be_true
    end

    it "is true when the sprint is running and sprint_id has changed" do
      @ticket.stub!(:sprint_running?).and_return true
      @ticket.stub!(:sprint_id_changed?).and_return true
      @ticket.send(:save_version?).should be_true
    end

    it "is false when estimated hours have not changed, even though sprint running" do
      @ticket.stub!(:sprint_running?).and_return true
      @ticket.send(:save_version?).should be_false
    end

    it "is false when if the sprint is not running, even though estimated hours changed" do
      @ticket.stub!(:estimated_changed?).and_return false
      @ticket.send(:save_version?).should be_false
    end
  end

  describe Ticket, '#estimated_at' do
    it "returns the original estimation on the day the ticket was created" do
      day = Date.parse '2008-10-01'
      @ticket_1.estimated_at(day).should == 1
    end

    it "returns the estimation on the day the ticket was updated for the first time" do
      day = Date.parse '2008-10-02'
      @ticket_1.estimated_at(day).should == 2
    end

    it "returns the estimation on the day the ticket was updated for the second time" do
      day = Date.parse '2008-10-03'
      @ticket_1.estimated_at(day).should == 3
    end

    it "returns the estimation on the day the ticket was updated last time" do
      day = Date.parse '2008-10-04'
      @ticket_1.estimated_at(day).should == 3
    end

    it "returns the estimation on the day the ticket was updated on the last day of sprint 1" do
      day = Date.parse '2008-10-07'
      @ticket_1.estimated_at(day).should == 4
    end

    it "returns the estimation on the day the ticket was updated on the first day of sprint 2" do
      day = Date.parse '2008-10-08'
      @ticket_1.estimated_at(day).should == 5
    end
  end
end

