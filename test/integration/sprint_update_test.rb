require 'test/test_helper'

class SprintUpdateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    http_auth!
  end
  
  def test_user_updates_a_sprint
    scenario :a_project, :two_releases, :two_sprints
    
    will_update_remote_milestone! @project, @sprint_1 do
      
      visits edit_sprint_path(@sprint_1)
      
      assert_updated @sprint_1, :name, :body do
        fills_in :name, :with => @sprint_1.name + ' (updated)'
        fills_in :body, :with => @sprint_1.body + ' (updated)'
        clicks_button :update
      end
      
      assert_response :success
    end
  end
end