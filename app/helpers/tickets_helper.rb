module TicketsHelper
  def sorted_sprint_path(sort)
    sprint_path(@sprint, :sort => sort)
  end
  
  def tickets_by_component(tickets, component = nil)
    tickets.select{|t| t.component_id == component.id }
  end
end