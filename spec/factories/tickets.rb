Factory.define :ticket, :class => Ticket do |f|
  f.remote_id 1
  f.version 1
  f.estimated 1
  f.closed 0
  f.state 'new'
  f.title 'title'
  f.body 'body'
  f.user {|u| u.association :user }
end

Factory.define :ticket_version, :class => Ticket::Version do |f|
  f.version 1
  f.estimated 1
end

module TicketScenarios
  def bunch_of_tickets!
    Ticket.delete_all
    
    on '2008-10-01' do
      @project = Factory :scrumtious
      @release = Factory :release_001
      
      @sprint_1 = Factory :sprint_1
      @sprint_2 = Factory :sprint_2
      
      @ticket_1 = create_ticket
      @ticket_2 = create_ticket :estimated => 3
      @ticket_3 = create_ticket
      @ticket_4 = create_ticket
      @ticket_5 = create_ticket :sprint => @sprint_2
    end

    on '2008-10-02' do @ticket_1.update_attributes :estimated => 2 end
    on '2008-10-03' do @ticket_1.update_attributes :estimated => 3 end
    on '2008-10-07' do @ticket_1.update_attributes :estimated => 4 end
    on '2008-10-08' do @ticket_1.update_attributes :sprint => @sprint_2, :estimated => 5 end
  end
  
  def create_ticket(options = {})
    options.reverse_update :project => @project, :release => @release, :sprint => @sprint_1
    Factory :ticket, options
  end
  
  def on(day)
    stub_time! Time.parse("#{day} 12:00:00 UTC")
    yield
    unstub_time!
  end
  
  def stub_time!(time)
    Time.stub!(:now).and_return time
    Time.now.stub!(:utc).and_return time
  end
  
  def unstub_time!
    Time.rspec_reset
    Time.now.rspec_reset
  end
end