require File.dirname(__FILE__) + '/../spec_helper'

describe Lighthouse::User, '#attributes_for_local' do
  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
    @remote_user = Lighthouse::User.new :id => 1, :name => 'John Doe'
  end
  
  it "maps remote attributes to local attributes" do
    expected = { 
      # :remote_id => @remote_user.id, 
      :name => @remote_user.name 
    }
    @remote_user.attributes_for_local.should == expected
  end
end