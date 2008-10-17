require 'test/test_helper'

class ProjectCreateTest < ActionController::IntegrationTest
  def setup
    http_auth!
  end
  
  def test_user_creates_a_project
    get projects_path
    clicks_link 'new project'
    
    assert_difference 'Project.count' do
      fills_in :name, :with => 'name'
      fills_in :project_remote_id, :with => 'project_remote_id'
      fills_in :project_lighthouse_account, :with => 'project_lighthouse_account'
      fills_in :project_lighthouse_token, :with => 'project_lighthouse_token'
      clicks_button :create
    end
    
    assert_response :success
  end
end