require 'test/test_helper'

class SprintCreateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    http_auth!
  end
  
  def test_user_creates_a_sprint
    scenario :a_project, :two_releases
    attributes = { :name => 'Sprint #1', :body => 'Sprint #1 description' }
    
    will_create_remote_milestone! @project, attributes do
      
      visits edit_project_path(@project)
      clicks_link 'new sprint'

      assert_difference 'Sprint.count' do
        selects  @release_1.name, :from => :release
        fills_in :name, :with => attributes[:name]
        fills_in :body, :with => attributes[:body]
        clicks_button :create
      end

      assert_response :success
    end
  end
end