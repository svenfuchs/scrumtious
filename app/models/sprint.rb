class Sprint < Milestone
  belongs_to :project
  belongs_to :release

  def ticket_groups(sort)
    tickets = self.tickets :order => order(sort)
    @groups ||= sort.to_sym == :assigned ? tickets.group_by(&:user) : [[nil, tickets]]
  end

  def tickets(options = {})
    options.reverse_merge! :conditions => {"#{Ticket.versioned_table_name}.sprint_id" => id},
                           :include => [:versions, :project, :release, :user, :activities],
                           :to => end_at
    @tickets ||= Ticket.all options
  end

  def release_id=(release_id)
    # TODO also update ticket versions ... maybe just a bulk update sql
    tickets.each{|t| t.update_attributes :release_id => release_id }
    self[:release_id] = release_id
  end
  
  def schedule
    @schedule ||= Schedule.new project, start_at, end_at
  end

  def burndown
    @burndown ||= Burndown.new(tickets, start_at, end_at)
  end

  def period
    [start_at, end_at]
  end

  def running?
    start_at <= Time.zone.today and Time.zone.today <= end_at
  end
  
  protected

    def order(sort)
      orders = {
        :assigned => 'users.name',
        :hours => 'tickets.estimated DESC',
        :url => 'tickets.remote_id',
        :ticket => 'tickets.remote_id',
        :default => 'tickets.state, tickets.priority, tickets.remote_id DESC, tickets.parent_id'
      }
      sort ||= :default
      [orders[sort.to_sym], orders[:default]].compact * ', '
    end
end