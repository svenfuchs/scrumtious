require 'synchronizer/lighthouse'

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
      p result
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

  def initialize(project_id)
    @project = ::Project.find(project_id) if project_id
    ::Lighthouse.account = @project.lighthouse_account
    ::Lighthouse.token = @project.lighthouse_token
  end
  
  def run!
    sync_users
    sync_milestones
    sync_tickets
    project.update_attributes! :synced_at => Time.now
  end
  
  def project_id
    @project.id
  end
  
  def id; end; def new_record?; true end # make form_for happy
  
  protected
  
    def sync_users
      lighthouse.users.each do |remote_user|
        User.sync_from_remote_user!(remote_user)
      end
    end
  
    def sync_tickets
      lighthouse.updated_tickets(project.synced_at).each do |remote_ticket|
        Ticket.sync_from_remote_ticket!(@project, remote_ticket)
      end
    end
  
    def sync_milestones
      lighthouse.milestones.each do |remote_milestone|
        Milestone.sync_from_remote_milestone!(@project, remote_milestone)
      end
    end
  
    def lighthouse
      @lighthouse ||= Lighthouse.new(@project.remote_id)
    end
end