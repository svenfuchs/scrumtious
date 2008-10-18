class Milestone < ActiveRecord::Base
  belongs_to :project
  
  def push!
    project.synchronizer.push! self
  end
end