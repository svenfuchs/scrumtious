require 'test/test_helper'
require 'active_resource/http_mock'

module ProjectSteps
  def creates_project
    get projects_path
    clicks_link 'new project'
    
    assert_difference 'Project.count' do
      fills_in :name, :with => 'project 1'
      fills_in :project_remote_id, :with => 'project_remote_id'
      fills_in :project_lighthouse_account, :with => 'project_lighthouse_account'
      fills_in :project_lighthouse_token, :with => 'project_lighthouse_token'
      clicks_button :create
    end
    
    assert_response :success
  end
  
  def pulls_project
    @ticket  = { :id => 1, :title => "title" }.to_xml(:root => "ticket")
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/ticket/1.xml", {}, @ticket
      # mock.get(path, request_headers = {}, body = nil, status = 200, response_headers = {})
    end
    Lighthouse::Ticket.find(:all)
    # stub_lighthouse!
    # clicks_post_link 'pull'
  end
  
  def picks_user(name)
    puts response.body
    selects name, :from => "current_user[id]"
    p @forms
  end
end

class SprintTest < ActionController::IntegrationTest
  include ProjectSteps
  
  def setup
    http_auth!
  end
  
  def test_awesomeness
    creates_project
    pulls_project
    picks_user "Sven"
  end
end