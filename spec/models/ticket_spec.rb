require File.dirname(__FILE__) + '/../spec_helper'

describe Ticket, '#sprint_id=' do
  before :each do 
    @ticket = Ticket.new
    @sprint = mock('sprint', :id => 1, :release_id => 2)
    Sprint.stub!(:find).and_return @sprint
  end

  it "it checks if the sprint is part of a release and if so assigns the ticket to the release as well" do
    @ticket.sprint_id = @sprint.id
    @ticket.release_id.should == @sprint.release_id
  end
end
