require 'test/test_helper'

class ProjectPullTest < ActionController::IntegrationTest
  include HttpMockHelper

  def setup
    http_auth!
    scenario :a_project, :two_releases, :two_sprints, :two_tickets, :two_users

    # set up http mock responses for various lighthouse requests
    will_fetch_remote_memberships!(@project, @users.map(&:id))
    will_fetch_remote_user!(@project, @user_1) 
    will_fetch_remote_user!(@project, @user_2)
    will_fetch_remote_milestones!(@project, @releases + @sprints)
    will_fetch_remote_tickets!(@project, @tickets, 'page=1&q=all')
    will_fetch_remote_tickets!(@project, [], 'page=2&q=all')
    
    # clear database so we can assert that mock remote data was saved locally
    clear_db! :except => 'projects'
  end
  
  def test_user_pulls_a_project
    visits project_path(@project)
    clicks_link 'pull'
    
    assert_equal 2, User.count, 'should have 2 users'
    assert_equal 4, Milestone.count, 'should have 2 milestones'
    assert_equal 2, Ticket.count, 'should have 2 tickets'
    
    assert_response :success
  end
  
  def clear_db!(options = {})
    except = Array(options[:except]) + ['schema_migrations']
    table_names = ActiveRecord::Base.connection.tables - except
    table_names.each{|t| ActiveRecord::Base.connection.execute "DELETE FROM #{t}" }
  end
end