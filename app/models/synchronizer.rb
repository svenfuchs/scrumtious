ActiveResource::Base.logger = RAILS_DEFAULT_LOGGER

require File.dirname(__FILE__) + '/synchronizer/lighthouse.rb'

class Synchronizer
  attr_reader :project, :lighthouse

  def initialize(project)
    @project = project.is_a?(::Project) ? project : ::Project.find(project)
    @lighthouse = Synchronizer::Lighthouse.new(@project)
  end
  
  def push!(local)
    if local.remote_id.blank?
      # TODO only update relevant changes to Lighthouse
      remote = lighthouse.from_local(local)
      if remote.save
        local.update_attributes :remote_id => remote.id
      else
        # TODO raise remote.errors
      end
    else
      type = local.is_a?(Milestone) ? 'Milestone' : local.class.name
      remote = lighthouse.send type.downcase, local.remote_id
      remote.update_attributes! local.attributes
    end
  end
  
  def pull!
    pull_users!
    pull_milestones!
    pull_tickets!
    project.update_attributes! :synced_at => Time.now
  end
  
  def pull_users!
    lighthouse.users.each{|u| update_local(u) }
  end

  def pull_milestones!
    lighthouse.milestones.each{|m| update_local(m) }
  end

  def pull_tickets!
    lighthouse.updated_tickets(project.synced_at).each{|t| update_local(t) }
  end
  
  def id; end; def new_record?; true end # make form_for happy
  
  protected
    
    def update_local(remote)
      klass = local_class remote
      local = klass.find_or_initialize_by_remote_id remote.id
      attributes = remote.attributes_for_local
      attributes.update!(:project => @project) if local.respond_to?(:project=)
      local.update_attributes! attributes
    end
    
    def local_class(object)
      if object.is_a? Lighthouse::Milestone
        object.name =~ /Release/i ? Release : Sprint
      else
        object.class.name.demodulize.constantize
      end
    end
end


  # cattr_accessor :sync
  # @@sync = true
  # 
  # class << self
  #   def with_no_sync
  #     old_sync, self.sync = self.sync, false # TODO not threadsafe
  #     yield
  #     self.sync = old_sync
  #   end
  #   
  #   alias :sync? :sync
  #   
  #   def no_sync!
  #     self.sync = false
  #   end
  # end

  # def project_id
  #   @project.id
  # end
  # 
  # def push_ticket(ticket)
  #   return unless self.class.sync?
  #   attributes = { :number => ticket.remote_id, :project_id => @project.remote_id }
  #   ticket.changes.each do |name, values|
  #     case name
  #     when 'user_id'
  #       attributes['assigned_user_id'] = ticket.user.remote_id if ticket.user 
  #     when 'sprint_id'
  #       attributes['milestone_id'] = ticket.sprint.remote_id if ticket.sprint
  #     when 'release_id'
  #       attributes['milestone_id'] = ticket.release.remote_id if ticket.release
  #     end
  #   end
  #   return if attributes.keys.size == 2
  #   ticket = ::Lighthouse::Ticket.new(attributes)
  #   ticket.save
  # end
  
