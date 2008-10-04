class Ticket < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Ticket'
  belongs_to :project
  belongs_to :release
  belongs_to :sprint
  belongs_to :user
  has_many :activities, :dependent => :destroy
  
  class << self
    def sync_from_remote_ticket!(project, remote_ticket)
      ticket = find_or_initialize_by_remote_id remote_ticket.id
      ticket.title = remote_ticket.title
      ticket.state = remote_ticket.state
      ticket.closed = remote_ticket.closed
      ticket.local = false
      ticket.project = project
      ticket.send :set_remote_milestone, remote_ticket.milestone
      ticket.send :set_remote_user, remote_ticket.assigned_user_id
      ticket.save!
    end
  end
  
  def lighthouse_url
    "http://artweb-design.lighthouseapp.com/projects/#{project.remote_id}/tickets/#{remote_id}"
  end
  
  def number_and_title
    "##{remote_id} - #{title}"
  end
  
  def activity_minutes(from_day = nil, to_day = nil)
    acts = from_day.nil? ? activities : activities_in_range(from_day, to_day)
    acts.map(&:minutes).compact.sum
  end
  
  def activities_in_range(from_day, to_day = nil)
    range = from_day..(to_day || from_day)
    activities.select{|a| range.include? a.date }
  end
  
  def actual_hours(sprint = nil)
    range = sprint ? [sprint.start_at, sprint.end_at] : []
    minutes = activity_minutes *range
    minutes.to_f / 60
  end
  
  def children
    self.class.find_by_parent_id self.id
  end
  
  def to_params
    attributes.slice 'remote_id', 'title', 'project_id', 'release_id', 'sprint_id', 'category_id', 'component_id', 'state'
  end
  
  protected
  
    def set_remote_milestone(milestone)
      return unless milestone
      type = milestone.title =~ /sprint/i ? Sprint : Release
      # self.send "#{type.name.underscore}=", type.find_by_remote_id(milestone.id)
      self.send "#{type.name.underscore}=", Milestone.find_by_remote_id(milestone.id)
    end
  
    def set_remote_user(assigned_user_id)
      self.user = User.find_by_remote_id(assigned_user_id) if assigned_user_id
    end
end