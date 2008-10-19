require 'test/test_helper'

class ReleaseCreateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    http_auth!
  end
  
  def test_user_creates_a_release
    scenario :a_project
    attributes = { :name => '0.0.1', :body => 'Release 0.0.1 description' }
    
    will_create_remote_milestone! @project, attributes do
      
      visits edit_project_path(@project)
      clicks_link 'new release'

      assert_difference 'Release.count' do
        fills_in :name, :with => attributes[:name]
        clicks_button :create
      end

      assert_response :success
    end
  end
end