module TicketsHelper
  def tickets_by_component(tickets, component = nil)
    tickets.select{|t| t.component_id == component.id }
  end
end