module RemoteMockHelper
  def remote_tickets_url(project)
    "/projects/#{project.remote_id}/tickets.xml"
  end
  
  def remote_ticket_url(project, id)
    "/projects/#{project.remote_id}/tickets/#{id}.xml"
  end
  def remote_milestones_url(project)
    "/projects/#{project.remote_id}/milestones.xml"
  end
  
  def remote_milestone_url(project, id)
    "/projects/#{project.remote_id}/milestones/#{id}.xml"
  end
  
  def lighthouse_headers
    { "Content-Type" => "application/xml", "X-LighthouseToken" => "lighthouse_token" }
  end
  
  def mock_get_to_ticket(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_ticket_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_post_to_ticket(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      url = remote_tickets_url(project)
      response = { "Location" => remote_ticket_url(project, id) }
      mock.post url, lighthouse_headers, xml, 201, response
    end
  end
  
  def mock_put_to_ticket(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.put remote_ticket_url(project, id), lighthouse_headers, xml
    end
  end
  
  def should_have_put_to_ticket(project, id, xml)
    url = remote_ticket_url(project, id)
    request = ActiveResource::Request.new :put, url, xml, lighthouse_headers
    ActiveResource::HttpMock.requests.include?(request).should be_true
  end
  
  def mock_get_to_milestone(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get remote_milestone_url(project, id), lighthouse_headers, xml
    end
  end
  
  def mock_post_to_milestone(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      url = remote_milestones_url(project)
      response = { "Location" => remote_milestone_url(project, id) }
      mock.post url, lighthouse_headers, xml, 201, response
    end
  end
  
  def mock_put_to_milestone(project, id, xml)
    ActiveResource::HttpMock.respond_to do |mock|
      mock.put remote_milestone_url(project, id), lighthouse_headers, xml
    end
  end
  
  def should_have_put_to_milestone(project, id, xml)
    url = remote_milestone_url(project, id)
    request = ActiveResource::Request.new :put, url, xml, lighthouse_headers
    ActiveResource::HttpMock.requests.include?(request).should be_true
  end
end

