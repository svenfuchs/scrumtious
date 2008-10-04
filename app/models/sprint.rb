class Sprint < Milestone
  belongs_to :project
  belongs_to :release
  has_many :tickets, :include => [:project, :release, :user, :activities], 
                     :order => 'tickets.state, tickets.remote_id DESC, tickets.parent_id'
  
  def release_id=(release_id)
    tickets.update_all :release_id => release_id
    self[:release_id] = release_id
  end
  
  def scheduled_days
    return [] unless start_at
    (0..(end_at - start_at).to_i).collect{|i| start_at + i.days }
  end
end