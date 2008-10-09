module Lighthouse  
  class Project
    include ActionView::Helpers::DateHelper
    
    def memberships(options = {})
      Membership.find(:all, :params => options.update(:project_id => id))
    end
  
    def updated_tickets(since)
      if since
        tickets :q => "updated:\"since #{time_ago_in_words(since - 1.minute)} ago\""
      else
        all_tickets
      end
    end
    
    def all_tickets
      page = 1
      result = paged = []
      while page == 1 or !paged.empty?
        paged = tickets(:q => :all, :page => page)
        result += paged
        page += 1
      end
      result.compact
    end
  end
  
  class Ticket
    def milestone
      @milestone ||= unless milestone_id.blank?
        # ::Milestone.find_by_remote_id(milestone_id) || 
        Milestone.find(milestone_id, :params => @prefix_options)
      end
    end
  end
end

class Synchronizer
  class Lighthouse
    include ::Lighthouse
    
    def initialize(project_id)
      @project_id = project_id
    end
  
    def project
      @project ||= Project.find(@project_id)
    end
    
    def users
      project.memberships.map{|m| User.find m.user_id }
    end

    def updated_tickets(since)
      project.updated_tickets(since)
    end
  
    def method_missing(method, *args)
      project.send method, *args
    end
  end
end

class Synchronizer
  attr_accessor :project
  cattr_accessor :sync
  @@sync = true
  
  class << self
    def with_no_sync
      old_sync, self.sync = self.sync, false # TODO not threadsafe
      yield
      self.sync = old_sync
    end
    
    alias :sync? :sync
    
    def no_sync!
      self.sync = false
    end
  end

  def initialize(project_id)
    @project = ::Project.find(project_id) if project_id
    ::Lighthouse.account = @project.lighthouse_account
    ::Lighthouse.token = @project.lighthouse_token
  end
  
  def run!
    return unless self.class.sync?
    pull_users
    pull_milestones
    pull_tickets
    project.update_attributes! :synced_at => Time.now
  end
  
  def project_id
    @project.id
  end
  
  def push_ticket(ticket)
    return unless self.class.sync?
    attributes = { :number => ticket.remote_id, :project_id => @project.remote_id }
    ticket.changes.each do |name, values|
      case name
      when 'user_id'
        attributes['assigned_user_id'] = ticket.user.remote_id if ticket.user 
      when 'sprint_id'
        attributes['milestone_id'] = ticket.sprint.remote_id if ticket.sprint
      when 'release_id'
        attributes['milestone_id'] = ticket.release.remote_id if ticket.release
      end
    end
    return if attributes.keys.size == 2
    ticket = ::Lighthouse::Ticket.new(attributes)
    # ::Lighthouse::Ticket.logger = RAILS_DEFAULT_LOGGER
    # RAILS_DEFAULT_LOGGER.info(ticket.inspect)
    ticket.save
  end
  
  def id; end; def new_record?; true end # make form_for happy
  
  protected
  
    def pull_users
      lighthouse.users.each do |remote_user|
        User.sync_from_remote_user!(remote_user)
      end
    end
  
    def pull_tickets
      lighthouse.updated_tickets(project.synced_at).each do |remote_ticket|
        Ticket.sync_from_remote_ticket!(@project, remote_ticket)
      end
    end
  
    def pull_milestones
      lighthouse.milestones.each do |remote_milestone|
        Milestone.sync_from_remote_milestone!(@project, remote_milestone)
      end
    end
  
    def lighthouse
      @lighthouse ||= Lighthouse.new(@project.remote_id)
    end
end