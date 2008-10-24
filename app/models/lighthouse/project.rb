module Lighthouse
  class Project
    class << self
      def attributes_from_local(project)
        { #:id => project.remote_id, 
          :name => project.name, 
          :body => project.body }
      end
    end
  end
end