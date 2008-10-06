require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper, '#jsonify_objects_for_select' do
  before :each do
    @releases = [ mock('release_bar', :id => 2, :name => 'bar'), 
                  mock('release_baz', :id => 3, :name => 'baz'), 
                  mock('release_foo', :id => 1, :name => 'foo') ]
  end
  
  it "returns a json object with ordered keys" do
    helper.send(:jsonify_objects_for_select, @releases, :id, :name).should == '{2: "bar", 3: "baz", 1: "foo"}'
  end
end
