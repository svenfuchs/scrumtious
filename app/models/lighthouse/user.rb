module Lighthouse  
  class User
    def attributes_for_local
      { # :remote_id => id, 
        :name => name }
    end
  end
end