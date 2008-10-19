require 'test/test_helper'

class ProjectUpdateTest < ActionController::IntegrationTest
  def setup
    http_auth!
  end
  
  def test_user_creates_a_project
    scenario :a_project
    
    visits project_path(@project)
    clicks_link 'edit'
      
    assert_updated @project, :name, :remote_id, :lighthouse_account, :lighthouse_token do
      fills_in :name, :with => @project.name + ' (updated)'
      fills_in :project_remote_id, :with => @project.remote_id + 1
      fills_in :project_lighthouse_account, :with => @project.lighthouse_account + ' (updated)'
      fills_in :project_lighthouse_token, :with => @project.lighthouse_token + ' (updated)'
      clicks_button :update
    end
    
    assert_response :success
  end
end