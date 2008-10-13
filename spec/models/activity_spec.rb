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

describe Activity, '#state=' do
  before :each do
    @activity = Activity.new
  end
  
  it "starts itself when passed 'started'" do
    @activity.should_receive :start!
    @activity.state = 'started'
  end

  it "stops itself when passed 'stopped'" do
    @activity.should_receive :stop!
    @activity.state = 'stopped'
  end
end

describe Activity, '#state' do
  before :each do
    @activity = Activity.new
  end
  
  it "returns 'started' if started_at is not nil" do
    @activity.stub!(:started_at).and_return Time.now
    @activity.state.should == 'started'
  end
  
  it "returns 'stopped' if started_at is nil" do
    @activity.stub!(:started_at).and_return nil
    @activity.state.should == 'stopped'
  end
end

describe Activity, '#started?' do
  before :each do
    @activity = Activity.new
  end
  
  it "returns true if started_at is not nil" do
    @activity.stub!(:started_at).and_return Time.now
    @activity.started?.should be_true
  end
  
  it "returns false if started_at is nil" do
    @activity.stub!(:started_at).and_return nil
    @activity.started?.should be_false
  end
end

