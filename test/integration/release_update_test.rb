require 'test/test_helper'

class ReleaseUpdateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    http_auth!
  end
  
  def test_user_updates_a_release
    scenario :a_project, :two_releases
    
    will_update_remote_milestone! @project, @release_1 do
      
      visits edit_release_path(@release_1)
      
      assert_updated @release_1, :name, :body do
        fills_in :name, :with => @release_1.name + ' (updated)'
        fills_in :body, :with => @release_1.body + ' (updated)'
        clicks_button :update
      end
      
      assert_response :success
    end
  end
end