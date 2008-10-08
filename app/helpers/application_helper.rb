# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def release_select_data_json
    jsonify_objects_for_select(@project.releases, :id, :name) if @project
  end

  def sprint_select_data_json
    jsonify_objects_for_select(@project.sprints, :id, :name) if @project
  end
  
  def user_select_data_json
    jsonify_objects_for_select(@project.members, :id, :first_name) if @project
  end
  
  private

    def jsonify_objects_for_select(objects, key, value, include_blank = true)
      objects.sort!{|l, r| l.send(value) <=> r.send(value)}
      p objects
      returning result = '{' do 
        result << objects.map do |obj| 
          # result << "'': ''" if include_blank
          "#{ActiveSupport::JSON.encode(obj.send(key))}: #{ActiveSupport::JSON.encode(obj.send(value))}"
        end * ', ' << '}'
      end
    end
end
