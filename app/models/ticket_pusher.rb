class TicketPusher < ActionController::Caching::Sweeper
  observe Ticket
  
  def after_save(ticket)
    Synchronizer.new(ticket.project_id).push_ticket(ticket)
  end
end

