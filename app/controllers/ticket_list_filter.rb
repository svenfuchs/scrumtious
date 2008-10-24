class TicketListFilter
  attr_reader :project, :params
  
  def initialize(project, params)
    @project = project
    @params = params || defaults
  end
  
  def defaults
    { :state => %w(new open hold), :sprint => 'any', :release => 'any' }
  end
  
  def active?(filter, value)
    Array(@params[filter]).include? value.to_s
  end
  
  def sql
    return '' unless params
    sql = []
    sql << state_sql
    sql << association_sql(:release)
    sql << association_sql(:sprint)
    sql.compact * ' AND '
  end
  
  def state_sql
    return nil if any?(:state)
    states = params[:state] || ['NULL']
    'tickets.state IN (' + states.map{|state| "'#{state}'"} * ', ' + ')'
  end
  
  def association_sql(type)
    return nil if any?(type)
    sql = []
    # sql = ["tickets.#{type}_id IS #{none?(type) ? '' : 'NOT '}NULL"]
    # sql << "tickets.#{type}_id IS NOT NULL"
    sql << "tickets.#{type}_id IN (" + ids(type) * ', ' + ')' unless ids(type).empty?
    '(' + sql.compact.join(' OR ') + ')' unless sql.compact.empty?
  end
  
  def ids(type)
    Array(params[type]) - %w(any none)
  end
  
  def none?(type)
    Array(params[type]).include? 'none'
  end
  
  def any?(type)
    Array(params[type]).include? 'any'
  end
end