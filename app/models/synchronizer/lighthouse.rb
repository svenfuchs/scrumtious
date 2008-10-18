require File.dirname(__FILE__) + '/../lighthouse.rb'

class Synchronizer
  class Lighthouse
    include ::Lighthouse
    
    def initialize(project)
      @project = project
      ::Lighthouse.init @project
    end
    
    def from_local(local)
      type = local.is_a?(::Milestone) ? 'Milestone' : local.class.name
      remote_class = "Lighthouse::#{type}".constantize
      attrs = remote_class.attributes_from_local(local)
      returning remote_class.new(attrs) do |m|
        m.prefix_options = { :project_id => @project.remote_id }
      end
    end
  
    def remote_project
      @remote_project ||= Project.find @project.remote_id
    end
    
    def milestone(id, options = {})
      Milestone.find id, :params => options.update(:project_id => @project.remote_id)
    end
    
    def ticket(id, options = {})
      Ticket.find id, :params => options.update(:project_id => @project.remote_id)
    end
    
    def users
      remote_project.memberships.map{|m| User.find m.user_id }
    end

    def updated_tickets(since)
      remote_project.updated_tickets(since)
    end
  end
end

