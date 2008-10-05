# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sprint_select_data_json
    Hash[*@project.sprints.all(:order => :name).map{|s| [s.id, s.name]}.flatten].to_json
  end
end
