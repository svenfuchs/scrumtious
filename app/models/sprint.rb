class Sprint < Milestone
  belongs_to :project
  belongs_to :release
  has_many :tickets, :include => [:project, :release, :user, :activities] do
    def sorted(order)
      orders = {
        :assigned => 'users.name',
        :hours => 'tickets.estimated DESC',
        :url => 'tickets.remote_id',
        :ticket => 'tickets.remote_id',
        :default => 'tickets.state, tickets.priority, tickets.remote_id DESC, tickets.parent_id'
      }
      order ||= :default
      order = [orders[order.to_sym], orders[:default]].compact * ', '
      find :all, :order => order
    end
    
    def grouped(order)
      tickets = sorted(order)
      (order.to_sym == :assigned) ? tickets.group_by(&:user) : [[nil, tickets]]
    end
  end
  
  def schedule
    @schedule ||= Schedule.new project, start_at
  end
  
  def scheduled_hours(user)
    start_at && end_at ? schedule.hours(user, start_at, end_at) : []
  end
  
  def period
    [start_at, end_at]
  end
  
  def release_id=(release_id)
    tickets.update_all :release_id => release_id
    self[:release_id] = release_id
  end
  
  def scheduled_days(to_date = Time.zone.today)
    return [] unless start_at
    to_date = end_at if end_at and end_at < to_date
    (0..(to_date - start_at).to_i).collect{|i| start_at + i.days }
  end
  
  def running?
    start_at <= Time.zone.today and Time.zone.today <= end_at
  end

  def burndown
    Burndown.new(tickets, start_at, end_at)
  end
end