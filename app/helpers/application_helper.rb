# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def lighthouse_url(ticket)
    "http://artweb-design.lighthouseapp.com/projects/#{ticket.project.remote_id}/tickets/#{ticket.remote_id}"
  end
  
  def all_projects_members
    Project.all.map(&:members).flatten.uniq.sort_by(&:name)
  end
  
  def to_hours(minutes, options = {:zero => ''})
    hours (minutes.to_f / 60).round(1), options
  end
  
  def hours(hours, options = {:zero => ''})
    hours > 0 ? hours : options[:zero]
  end
  
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
      returning result = '{' do 
        result << objects.sort{|l, r| l.send(value) <=> r.send(value)}.map do |obj| 
          # result << "'': ''" if include_blank # WTF
          "#{ActiveSupport::JSON.encode(obj.send(key))}: #{ActiveSupport::JSON.encode(obj.send(value))}"
        end * ', ' << '}'
      end
    end
end
