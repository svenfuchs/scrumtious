class Sprint < Milestone
  has_many :projects, :through => :remote_instances
  has_many :remote_instances, :as => :local
  
  def exists_remote?(project_id)
    !!remote_instance(project_id)
  end
  
  def remote_id(project_id)
    instance = remote_instance(project_id)
    instance.id if instance
  end
  
  def remote_instance(project_id)
    remote_instances.find_by_project_id project_id
  end
  
  def ticket_groups(sort)
    tickets = self.tickets :order => order(sort)
    @groups ||= sort.to_sym == :assigned ? tickets.group_by(&:user) : [[nil, tickets]]
  end

  def tickets(options = {})
    options.reverse_merge! :conditions => {"#{Ticket.versioned_table_name}.sprint_id" => id},
                           :include => [:versions, :user, :activities],
                           :to => end_at
    @tickets ||= Ticket.all options
  end

  def schedule
    @schedule ||= Schedule.new start_at, end_at
  end

  def burndown
    @burndown ||= Burndown.new(tickets, start_at, end_at)
  end

  def period
    [start_at, end_at]
  end

  def running?
    # period.include?(Time.parse('2008-10-02'))
    started? and !ended?
  end
  
  def started?
    start_at and start_at <= Time.zone.today
  end
  
  def ended?
    end_at and end_at < Time.zone.today
  end
  
  def push!
    projects.each{|project| project.synchronizer.push! self }
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