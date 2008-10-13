require File.dirname(__FILE__) + '/../spec_helper'

describe "projects :edit page" do
  before :each do
    users = [mock_model(User, :id => 1, :name => 'user 1'), mock_model(User, :id => 2, :name => 'user 2')]
    members = [users.first]
    project = mock_model(Project, :id => 1, :members => members)
    
    assigns[:users] = users
    assigns[:project] = project
  end
  
  it "shows a form for selecting project members from the account user list" do
    render 'projects/_members'
    response.should have_tag('form') do |form|
      form.should have_tag('input[type=?][name=?][value=?][checked=?]', 'checkbox', 'project[member_ids][]', '1', 'checked')
      form.should have_tag('input[type=?][name=?][value=?]', 'checkbox', 'project[member_ids][]', '2') do |tags|
        tags.first.attributes['checked'].should be_nil
      end
    end
  end
end