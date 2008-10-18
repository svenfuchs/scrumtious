require 'lighthouse/project'
require 'lighthouse/milestone'
require 'lighthouse/ticket'
require 'lighthouse/user'

module Lighthouse  
  class << self
    def init(project)
      self.account = project.lighthouse_account
      self.token = project.lighthouse_token
    end
  end
end

