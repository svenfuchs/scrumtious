require File.dirname(__FILE__) + '/../spec_helper'

describe Synchronizer, "sync" do
  it "can read" do
    lambda{ Synchronizer.sync }.should_not raise_error
  end
  
  it "can write" do
    lambda{ Synchronizer.sync = 'foo' }.should_not raise_error
    Synchronizer.sync.should == 'foo'
  end
end

describe Synchronizer, "with_no_sync" do
  it "turns sync off while executing the block" do
    Synchronizer.with_no_sync do
      Synchronizer.sync?.should == false
    end
  end
end