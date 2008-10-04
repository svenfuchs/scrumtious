module ActivitiesHelper
  def activities
    Activity.all(:order => "started DESC, updated_at DESC", :limit => 100)
  end
  
  def activity_lighthouse_link(activity)
    link_to "##{h(activity.ticket.remote_id)}", activity.ticket.lighthouse_url
  end
  
  def activity_ticket_link(activity)
    link_to h(activity.ticket.title), activity.ticket
  end
  
  def toggle_ticket_activity_link(ticket)
    return unless current_user
    attributes = {:ticket_id => ticket.id, :user_id => current_user.id, :date => Time.zone.today}
    activity = Activity.find :first, :conditions => attributes, :order => 'id DESC'
    if !activity
      create_activity_link(attributes)
    elsif activity.started.blank?
      restart_activity_link(activity, attributes)
    else
      stop_activity_link(activity, attributes)
    end
  end
  
  def stop_activity_link(activity, attributes)
    path = activity_path(activity, :activity => attributes.update(:started => nil), :return_to => request.path)
    link_to "stop", path, :method => :put, :class => "toggle stop"
  end
  
  def restart_activity_link(activity, attributes)
    path = activity_path(activity, :activity => attributes.update(:started => Time.zone.now), :return_to => request.path)
    link_to "start", path, :method => :put, :class => "toggle start"
  end
  
  def create_activity_link(attributes)
    path = activities_path(:activity => attributes.update(:started => Time.zone.now), :return_to => request.path)
    link_to "start", path, :method => :post, :class => "toggle start"
  end
  
  def toggle_activity_link(activity)
    if activity.started
      link_to "stop", activity_path(activity, :activity => {:started => nil}, :return_to => request.path), :method => :put
    else
      link_to "start", activity_path(activity, :activity => {:started => Time.zone.now}, :return_to => request.path), :method => :put
    end
  end
  
  def activity_time_in_words(activity)
    distance_of_time_in_words Time.now + activity.minutes.to_i.minutes, Time.now, false
  end
  
  def activity_hours_on(ticket, day)
    minutes = ticket.activity_minutes(day)
    hours = (minutes.to_f / 60).round(1)
    hours > 0 ? hours : ''
  end
end