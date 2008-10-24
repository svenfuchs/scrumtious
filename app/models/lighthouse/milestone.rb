module Lighthouse  
  class Milestone
    class << self
      def attributes_from_local(local)
        { :title => "#{local.class.name} #{local.name}", 
          :body => local.body,
          :due_on => local.end_at ? local.end_at - 1.day : nil }
      end
    end
      
    def attributes_for_local
      { :remote_id => id, 
        :name => ::Milestone.normalize_name!(title), 
        :end_at => due_on ? due_on + 1.day : nil }
    end
      
    def update_attributes!(attributes)
      attributes.each do |name, value|
        self.send "#{name}=", value unless name.to_sym == :id
      end
      save
    end
  end
end