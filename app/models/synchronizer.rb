ActiveResource::Base.logger = RAILS_DEFAULT_LOGGER

require File.dirname(__FILE__) + '/synchronizer/lighthouse.rb'

class Synchronizer
  attr_reader :project, :lighthouse

  def initialize(project)
    @project = project.is_a?(::Project) ? project : ::Project.find(project)
    @lighthouse = Synchronizer::Lighthouse.new(@project)
  end
  
  # TODO only update relevant changes to Lighthouse
  def push!(local)
    if remote_id = local.remote_id(project.id)
      type = local.is_a?(Milestone) ? 'Milestone' : local.class.name
      remote = lighthouse.send type.downcase, remote_id
      remote.update_attributes! local.attributes
    else
      remote = lighthouse.from_local(local)
      if remote.save
        local.update_attributes :remote_id => remote.id
      else
        # TODO raise remote.errors
      end
    end
  end
  
  def pull!
    pull_users!
    pull_milestones!
    pull_tickets!
    project.update_attributes! :synced_at => Time.now
  end
  
  def pull_users!
    lighthouse.users.each do |remote| 
      local = User.find_or_initialize_by_remote_id(remote.id)
      update_local local, remote
    end
  end

  def pull_milestones!
    lighthouse.milestones.each do |remote|
      klass = remote.title =~ /Release/i ? Release : Sprint
      local = klass.find_or_initialize_for(@project, remote)
      update_local local, remote
    end
  end

  def pull_tickets!
    lighthouse.updated_tickets(project.synced_at).each do |remote|
      ticket = Ticket.find_or_initialize_by_remote_id_and_local(remote.id, 0)
      update_local ticket, remote
    end
  end
  
  def id; end; def new_record?; true end # make form_for happy
  
  protected
    
    def update_local(local, remote)
      attributes = remote.attributes_for_local
      attributes.update(:project => @project) if local.respond_to?(:project=)
      local.update_attributes! attributes
      update_local_remote_instance(local, remote) if local.is_a? Sprint
    end
    
    def update_local_remote_instance(local, remote)
      return if local.remote_instance(@project.id)
      local.remote_instances.create! :project => @project, :local => local, :remote_id => remote.id
    end
end