require 'test/test_helper'

class TicketCreateTest < ActionController::IntegrationTest
  include HttpMockHelper
  
  def setup
    scenario :a_project, :two_releases, :two_sprints, :two_users
    @project.members << @user_1 << @user_2
    @attributes = { :title => 'Ticket 1', :body => 'Ticket 1 description', :estimated => 1 }

    http_auth!
  end
  
  def test_user_creates_a_ticket
    will_create_remote_ticket! @project, @attributes do
      
      visits project_path(@project)
      clicks_link 'new ticket'

      assert_difference 'Ticket.count' do
        selects  @release_1.name, :from => :release
        selects  @sprint_1.name, :from => :sprint
        selects  @user_1.first_name, :from => "Assigned to"
        fills_in :title, :with => @attributes[:title]
        # fills_in :body, :with => @attributes[:body]
        fills_in :estimated, :with => @attributes[:estimated]
        clicks_button :create
      end

      assert_response :success
    end
  end
end