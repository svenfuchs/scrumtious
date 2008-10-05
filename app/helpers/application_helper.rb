# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def release_select_data_json
    Hash[*@project.releases.all(:order => :name).map{|s| [s.id, s.name]}.flatten].to_json if @project
  end

  def sprint_select_data_json
    Hash[*@project.sprints.all(:order => :name).map{|s| [s.id, s.name]}.flatten].to_json if @project
  end
  
  def user_select_data_json
    Hash[*User.all(:order => :name).map{|s| [s.id, s.first_name]}.flatten].to_json
  end
end
