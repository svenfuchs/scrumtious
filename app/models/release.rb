class Release < Milestone
  has_many :sprints
  has_many :tickets, :include => [:project, :release, :user], 
                     :order => 'tickets.sprint_id DESC, tickets.state, tickets.remote_id DESC, tickets.parent_id'
end