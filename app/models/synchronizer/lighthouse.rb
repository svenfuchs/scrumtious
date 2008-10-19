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
    
    def milestones(options = {})
      Lighthouse::Milestone.find :all, :params => options.update(:project_id => @project.remote_id)
    end
    
    def milestone(id, options = {})
      Lighthouse::Milestone.find id, :params => options.update(:project_id => @project.remote_id)
    end
    
    def ticket(id, options = {})
      Lighthouse::Ticket.find id, :params => options.update(:project_id => @project.remote_id)
    end
    
    def users
      memberships.map{|m| Lighthouse::User.find m.user_id }
    end
    
    def memberships(options = {})
      Lighthouse::Membership.find :all, :params => options.update(:project_id => @project.remote_id)
    end
    
    def tickets(options = {})
      Ticket.find(:all, :params => options.update(:project_id => @project.remote_id))
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
end

