require File.expand_path(File.dirname(__FILE__)) + "/http_mock_patch.rb"

module HttpMockHelper
  def will_fetch_remote_tickets!(project, tickets, query_string = '')
    Lighthouse.init project

    remote_tickets = tickets.map do |ticket|
      Lighthouse::Ticket.new Lighthouse::Ticket.attributes_from_local(ticket)
    end
    xml = remote_tickets.to_xml(:root => 'tickets', :children => 'ticket')

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_tickets_url(project, query_string), lighthouse_headers, xml
    end
  end
   
  def will_fetch_remote_milestones!(project, milestones)
    Lighthouse.init project

    remote_milestones = milestones.map do |milestone|
      Lighthouse::Milestone.new Lighthouse::Milestone.attributes_from_local(milestone)
    end
    xml = remote_milestones.to_xml(:root => 'milestones', :children => 'milestone')

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_milestones_url(project), lighthouse_headers, xml
    end
  end
  
  def will_fetch_remote_memberships!(project, user_ids)
    Lighthouse.init project

    remote_memberships = user_ids.map do |user_id|
      Lighthouse::Membership.new :user_id => user_id, :project => remote_project_url(@project)
    end
    xml = remote_memberships.to_xml(:root => 'memberships', :children => 'membership')

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_memberships_url(project), lighthouse_headers, xml
    end
  end

  def will_fetch_remote_user!(project, user)
    remote_user = Lighthouse::User.new :id => user.remote_id, :name => user.name
    xml = remote_user.to_xml
    
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_user_url(project, user.id), lighthouse_headers, xml
    end
  end
  
  def will_create_remote_milestone!(project, attributes, remote_id = 1)
    milestone = Milestone.new attributes
    remote_milestone = Synchronizer::Lighthouse.new(project).from_local milestone
    mock_post_to_milestones project, remote_milestone.to_xml, remote_id
    
    if block_given?
      yield
      should_have_posted_to_milestones project, remote_milestone.to_xml
    end
  end
  
  def will_update_remote_milestone!(project, milestone)
    remote_milestone = Synchronizer::Lighthouse.new(project).from_local milestone
    
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_milestone_url(project, remote_milestone.id), lighthouse_headers, remote_milestone.to_xml
      mock.put remote_milestone_url(project, remote_milestone.id), lighthouse_headers, remote_milestone.to_xml
    end
    
    if block_given?
      yield
      should_have_put_to_milestone project, remote_milestone.id, remote_milestone.to_xml
    end
  end
  
  def will_create_remote_ticket!(project, attributes, remote_id = 1)
    ticket = Ticket.new attributes
    remote_ticket = Synchronizer::Lighthouse.new(project).from_local ticket

    mock_post_to_tickets project, remote_ticket.to_xml, remote_id
    
    if block_given?
      yield
      should_have_posted_to_tickets project, remote_ticket.to_xml
    end
  end
  
  def will_update_remote_ticket!(project, ticket)
    remote_ticket = Synchronizer::Lighthouse.new(project).from_local ticket

    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_ticket_url(project, remote_ticket.id), lighthouse_headers, remote_ticket.to_xml
      mock.put remote_ticket_url(project, remote_ticket.id), lighthouse_headers, remote_ticket.to_xml
    end
    
    if block_given?
      yield
      should_have_put_to_ticket project, remote_ticket.id, remote_ticket.to_xml
    end
  end
  
  
  def mock_get_to_user(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_user_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_get_to_memberships(project, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_memberships_url(project), lighthouse_headers, xml
    end
  end
  
  def mock_get_to_ticket(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_ticket_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_post_to_tickets(project, xml, remote_id)
    ActiveResource::HttpMock.respond_to do |mock|
      url = remote_tickets_url(project)
      response = { "Location" => remote_ticket_url(project, remote_id) }
      mock.post url, lighthouse_headers, xml, 201, response
    end
  end
  
  def mock_put_to_ticket(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.put remote_ticket_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_get_to_milestone(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_milestone_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_post_to_milestones(project, xml, remote_id)
    ActiveResource::HttpMock.respond_to do |mock|
      url = remote_milestones_url(project)
      response = { "Location" => remote_milestone_url(project, remote_id) }
      mock.post url, lighthouse_headers, xml, 201, response
    end
  end
  
  def mock_put_to_milestone(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.put remote_milestone_url(project, id), lighthouse_headers, xml
    end
  end
  
  
  def should_have_put_to_ticket(project, id, xml)
    url = remote_ticket_url(project, id)
    request = ActiveResource::Request.new :put, url, xml, lighthouse_headers
    assert ActiveResource::HttpMock.requests.include?(request)
  end
  
  def should_have_posted_to_tickets(project, xml)
    url = remote_tickets_url(project)
    request = ActiveResource::Request.new :post, url, xml, lighthouse_headers
    msg = "should have POSTed to remote tickets"
    assert ActiveResource::HttpMock.requests.include?(request), msg
  end
  
  def should_have_posted_to_milestones(project, xml)
    url = remote_milestones_url(project)
    request = ActiveResource::Request.new :post, url, xml, lighthouse_headers
    msg = "should have POSTed to remote milestones"
    assert ActiveResource::HttpMock.requests.include?(request), msg
  end
  
  def should_have_put_to_milestone(project, id, xml)
    url = remote_milestone_url(project, id)
    request = ActiveResource::Request.new :put, url, xml, lighthouse_headers
    msg = "should have PUT to remote milestone #{id}"
    assert ActiveResource::HttpMock.requests.include?(request), msg
  end
  
  
  def remote_user_url(project, id)
    "/users/#{id}.xml"
  end
  
  def remote_project_url(project)
    # http://#{project.lighthouse_account}.lighthouseapp.com
    "/projects/#{project.remote_id}"
  end
  
  def remote_memberships_url(project)
    remote_project_url(project) + "/memberships.xml"
  end
  
  def remote_tickets_url(project, query_string = nil)
    remote_project_url(project) + "/tickets.xml" + (query_string ? "?#{query_string}" : '')
  end
  
  def remote_ticket_url(project, id)
    remote_project_url(project) + "/tickets/#{id}.xml"
  end
  
  def remote_milestones_url(project)
    remote_project_url(project) + "/milestones.xml"
  end
  
  def remote_milestone_url(project, id)
    remote_project_url(project) + "/milestones/#{id}.xml"
  end
  
  def lighthouse_headers
    { "Content-Type" => "application/xml", "X-LighthouseToken" => "lighthouse_token" }
  end
end

