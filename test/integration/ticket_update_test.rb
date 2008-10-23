require 'test/test_helper'

class TicketUpdateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    scenario :a_project, :two_releases, :two_sprints, :two_tickets, :two_users
    @project.members << @user_1 << @user_2

    http_auth!
  end
  
  def test_user_updates_a_ticket
    will_update_remote_ticket! @project, @ticket_1 do
      
      visits edit_ticket_path(@ticket_1)

      assert_updated @ticket_1, :sprint_id, :user_id, :title, :estimated do
        selects  @sprint_2.name, :from => :sprint
        selects  @user_2.first_name, :from => "Assigned to"
        fills_in :title, :with => @ticket_1.title + ' (updated)'
        # fills_in :body, :with => @ticket_1.body + ' (updated)'
        fills_in :estimated, :with => @ticket_1.estimated + 1
        clicks_button :update
      end
      
      assert_response :success
    end
  end
end