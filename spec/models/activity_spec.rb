require File.dirname(__FILE__) + '/../spec_helper'

describe Activity, '#start!' do
  before :each do
    @other_activity = Activity.new :state => 'started'
    user = mock 'user', :activities => mock('activities', :current => @other_activity)
    @activity = Activity.new 
    @activity.stub!(:user).and_return user
  end
  
  it "starts the activity" do
    @activity.start!
    @activity.started?.should be_true
  end

  it "stops the currently running activity by the current user" do
    @activity.start!
    @other_activity.started?.should be_false
  end
end
