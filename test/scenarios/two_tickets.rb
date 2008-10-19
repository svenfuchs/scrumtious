Scenario.define :two_tickets do
  scenario :two_users unless @user_1
  
  attrs = { 
    :project => @project,
    # :release => @release_1,
    :sprint => @sprint_1,
    :user => @user_1,
    :remote_id => 1, 
    :title => 'Ticket 1 title', 
    :body => 'Ticket 1 description', 
    :estimated => 1 
  }
  @ticket_1 = Ticket.create attrs.update(:project => @project)

  attrs = { 
    :project => @project,
    :release => @release_2,
    :sprint => @sprint_2,
    :user => @user_2,
    :remote_id => 2, 
    :title => 'Ticket 2 title', 
    :body => 'Ticket 2 description', 
    :estimated => 2 
  }
  @ticket_2 = Ticket.create attrs.update(:project => @project)
  
  @tickets = @ticket_1, @ticket_2
end