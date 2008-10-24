class Release < Milestone
  belongs_to :project
  has_many :tickets, :include => [:project, :release, :user], 
                     :order => 'tickets.sprint_id DESC, tickets.state, tickets.remote_id DESC, tickets.parent_id'

  def remote_id(project_id = nil)
    self[:remote_id]
  end
  
  def push!
    project.synchronizer.push! self
  end
end