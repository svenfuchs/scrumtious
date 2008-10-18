module Lighthouse
  class Project
    include ActionView::Helpers::DateHelper
    
    class << self
      def attributes_from_local(project)
        { :id => project.remote_id, :name => project.name, :body => project.body }
      end
    end
    
    # def milestone(id, options = {})
    #   Milestone.find id, :params => options.update(:project_id => id)
    # end
    # 
    # def memberships(options = {})
    #   Membership.find :all, :params => options.update(:project_id => id)
    # end
  
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