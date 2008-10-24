require File.dirname(__FILE__) + '/../spec_helper'

describe Synchronizer, '#push!' do
  include HttpMockHelper

  before :each do
    @project = Factory :scrumtious
    @ticket = Factory :ticket, :project => @project
    @synchronizer = @project.synchronizer
    @lighthouse = @synchronizer.send :lighthouse

    @remote_project = @lighthouse.from_local @project
    @remote_ticket = @lighthouse.from_local @ticket
  end

  describe "with no remote_id" do
    before :each do
      mock_post_to_tickets @project, @remote_ticket.to_xml, @ticket.remote_id
      @ticket.remote_id = nil
    end

    it "instantiates and saves a new remote ticket" do
      @lighthouse.should_receive(:from_local).with(@ticket).and_return @remote_ticket
      @remote_ticket.should_receive(:save)
      @synchronizer.push! @ticket
    end

    it "updates the ticket's remote_id from the new remote ticket" do
      @ticket.should_receive(:update_attributes).with :remote_id => @remote_ticket.id
      @synchronizer.push! @ticket
    end
  end

  describe "with a remote_id" do
    before :each do
      @lighthouse.stub!(:ticket).and_return @remote_ticket
      @remote_ticket.stub!(:update_attributes!)
      mock_get_to_ticket @project, @ticket.remote_id, @remote_ticket.to_xml
    end

    it "fetches the remote ticket" do
      @lighthouse.should_receive(:ticket).with(@ticket.remote_id).and_return @remote_ticket
      @synchronizer.push! @ticket
    end

    it "updates its attributes to the remote ticket" do
      @remote_ticket.should_receive(:update_attributes!).with @ticket.attributes
      @synchronizer.push! @ticket
    end
  end
end

describe Synchronizer, '#push! given a release' do
  include HttpMockHelper

  before :each do
    @project = Factory :scrumtious
    @release = Factory :release_001
    @synchronizer = @project.synchronizer
    @lighthouse = @synchronizer.send :lighthouse

    @remote_project = @lighthouse.from_local @project
    @remote_milestone = @lighthouse.from_local @release
  end

  describe "with no remote_id" do
    before :each do
      @release.remote_id = nil
      mock_post_to_milestones @project, @remote_milestone.to_xml, @release.remote_id
    end

    it "instantiates and saves a new remote milestone" do
      @lighthouse.should_receive(:from_local).with(@release).and_return @remote_milestone
      @remote_milestone.should_receive(:save)
      @synchronizer.push! @release
    end

    it "updates the release's remote_id from the new remote milestone" do
      @release.should_receive(:update_attributes).with :remote_id => @remote_milestone.id
      @synchronizer.push! @release
    end
  end

  describe "with a remote_id" do
    before :each do
      @lighthouse.stub!(:milestone).and_return @remote_milestone
      @remote_milestone.stub!(:update_attributes!)
      mock_get_to_milestone @project, @release.remote_id, @remote_milestone.to_xml
    end

    it "fetches the remote milestone" do
      @lighthouse.should_receive(:milestone).with(@release.remote_id).and_return @remote_milestone
      @synchronizer.push! @release
    end

    it "updates its attributes to the remote milestone" do
      @remote_milestone.should_receive(:update_attributes!).with @release.attributes
      @synchronizer.push! @release
    end
  end
end

describe Synchronizer, '#push! given a sprint' do
  include HttpMockHelper

  before :each do
    @project = Factory :scrumtious
    @sprint = Factory :sprint_1
    @synchronizer = @project.synchronizer
    @lighthouse = @synchronizer.send :lighthouse

    @remote_project = @lighthouse.from_local @project
    @remote_milestone = @lighthouse.from_local @sprint
  end

  describe "with no remote_id" do
    before :each do
      mock_post_to_milestones @project, @remote_milestone.to_xml, 1
      @sprint.remote_id = nil
    end

    it "instantiates and saves a new remote milestone" do
      @lighthouse.should_receive(:from_local).with(@sprint).and_return @remote_milestone
      @remote_milestone.should_receive(:save)
      @synchronizer.push! @sprint
    end

    it "updates the sprint's remote_id from the new remote milestone" do
      @sprint.should_receive(:update_attributes).with :remote_id => @remote_milestone.id
      @synchronizer.push! @sprint
    end
  end

  describe "with a remote_id" do
    before :each do
      @lighthouse.stub!(:milestone).and_return @remote_milestone
      @remote_milestone.stub!(:update_attributes!)
      @remote_instance = RemoteInstance.create! :remote_id => 1, :project => @project, :local => @sprint
      mock_get_to_milestone @project, @remote_instance.remote_id, @remote_milestone.to_xml
    end

    it "fetches the remote milestone" do
      @lighthouse.should_receive(:milestone).with(@remote_instance.remote_id).and_return @remote_milestone
      @synchronizer.push! @sprint
    end

    it "updates its attributes to the remote milestone" do
      @remote_milestone.should_receive(:update_attributes!).with @sprint.attributes
      @synchronizer.push! @sprint
    end
  end
end

describe Synchronizer, '#pull_milestones!' do
  include HttpMockHelper

  before :each do
    @project = Factory :scrumtious
    @synchronizer = @project.synchronizer
    @remote_milestone = Lighthouse::Milestone.new :id => 1, :title => 'Sprint #1', :due_on => Time.parse('2008-10-10')
    @sprint = Sprint.new
    Sprint.stub!(:find_or_initialize_by_remote_id).and_return @sprint

    @synchronizer.send(:lighthouse).stub!(:milestones).and_return [@remote_milestone]
    @synchronizer.stub!(:update_local_remote_instance)
  end

  it "updates local milestones from remote milestones" do
    @synchronizer.should_receive(:update_local).with(@remote_milestone).and_return @sprint
    @synchronizer.pull_milestones!
  end

  it "updates local remote_instances from a remote milestone if it is a sprint" do
    @synchronizer.should_receive(:update_local_remote_instance).with @sprint, @remote_milestone
    @synchronizer.pull_milestones!
  end
end

describe Synchronizer, '#pull_users!' do
  include HttpMockHelper

  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
    @remote_user = Lighthouse::User.new :id => 1, :name => 'John Doe'
    @synchronizer.send(:lighthouse).stub!(:users).and_return [@remote_user]
  end

  it "updates local users from remote users" do
    @synchronizer.should_receive(:update_local).with @remote_user
    @synchronizer.pull_users!
  end
end

describe Synchronizer, "#update_local (given a User)" do
  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
    @remote_user = Lighthouse::User.new :id => 1, :name => 'John Doe'

    @local_attributes = {:remote_id => 1, :name => 'John Doe'}
    @remote_user.stub!(:attributes_for_local).and_return @local_attributes

    @user = User.new
    User.stub!(:find_or_initialize_by_remote_id).and_return @user
  end

  it "fetches a user instance with :find_or_initialize" do
    User.should_receive(:find_or_initialize_by_remote_id).with(@remote_user.id).and_return @user
    @synchronizer.send(:update_local, @remote_user)
  end

  it "updates the user with mapped attributes from remote user" do
    @user.should_receive(:update_attributes!).with @local_attributes
    @synchronizer.send(:update_local, @remote_user)
  end
end

describe Synchronizer, "#update_local_remote_instance (given a Sprint)" do
  before :each do
    @project = Factory :scrumtious
    @synchronizer = @project.synchronizer
    @remote_milestone = Lighthouse::Milestone.new :id => 1, :title => 'Sprint #1', :due_on => Time.parse('2008-10-10')
    @sprint = Sprint.new
  end

  it "creates a new remote_instance for the sprint when it does not exist" do
    @sprint.stub!(:remote_instance).and_return nil
    attributes = {:local => @sprint, :project => @project, :remote_id => @remote_milestone.id}
    @sprint.remote_instances.should_receive(:create!).with attributes
    @synchronizer.send(:update_local_remote_instance, @sprint, @remote_milestone)
  end

  it "does not create a new remote_instance for the sprint when it already exists" do
    @sprint.stub!(:remote_instance).and_return mock('remote_instance')
    @sprint.remote_instances.should_not_receive :create!
    @synchronizer.send(:update_local_remote_instance, @sprint, @remote_milestone)
  end
end

describe Synchronizer, '#local_class' do
  before :each do
    @synchronizer = Factory(:scrumtious).synchronizer
  end

  it "returns User when given Lighthouse::User" do
    @synchronizer.send(:local_class, Lighthouse::User.new).should == User
  end

  it "returns Project when given Lighthouse::Project" do
    @synchronizer.send(:local_class, Lighthouse::Project.new).should == Project
  end

  it "returns Release when given Lighthouse::Milestone with a name starting with 'Release'" do
    release = Lighthouse::Milestone.new(:title => 'Release 0.0.1')
    @synchronizer.send(:local_class, release).should == Release
  end

  it "returns Sprint when given Lighthouse::Milestone with a name not starting with 'Release'" do
    sprint = Lighthouse::Milestone.new(:title => 'Sprint #1')
    @synchronizer.send(:local_class, sprint).should == Sprint
  end
end
