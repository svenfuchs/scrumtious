module Lighthouse  
  class Ticket
    class << self
      def attributes_from_local(ticket)
        { :id => ticket.remote_id, 
          :number => ticket.remote_id, # weird ...
          :title => ticket.title, 
          :body => ticket.body,
          :state => ticket.state,
          :closed => ticket.closed,
          :milestone_id => ticket.remote_milestone_id,
          :assigned_user_id => ticket.remote_user_id }
      end
    end
      
    def attributes_for_local
      # TODO ... this could go wrong. how to recover?
      user = ::User.find_by_remote_id(assigned_user_id)
      milestone = ::Milestone.find_by_remote_id(milestone_id)
      milestone_type = milestone.class.name.underscore
      
      { :remote_id => id, 
        :title => title, 
        :state => state,
        :closed => closed,
        :"#{milestone_type}_id" => milestone.id,
        :user_id => user.id }
    end
      
    def update_attributes!(attributes)
      attributes.each do |name, value|
        self.send "#{name}=", value # unless name.to_sym == :id
      end
      save
    end
      
    def milestone
      @milestone ||= unless milestone_id.blank?
        Milestone.find milestone_id, :params => @prefix_options
      end
    end
  end
end