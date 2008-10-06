# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def release_select_data_json
    jsonify_objects_for_select(@project.releases.all(:order => :name), :id, :name) if @project
  end

  def sprint_select_data_json
    jsonify_objects_for_select(@project.sprints.all(:order => :name), :id, :name) if @project
  end
  
  def user_select_data_json
    Hash[*User.all(:order => :name).map{|s| [s.id, s.first_name]}.flatten].to_json
  end
  
  private

    def jsonify_objects_for_select(objects, key, value, include_blank = true)
      returning result = '{' do 
        result << objects.map do |obj| 
          # result << "'': ''" if include_blank
          "#{ActiveSupport::JSON.encode(obj.send(key))}: #{ActiveSupport::JSON.encode(obj.send(value))}"
        end * ', ' << '}'
      end
    end
end
