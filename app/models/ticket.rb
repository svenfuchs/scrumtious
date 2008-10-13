class Ticket < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Ticket'
  belongs_to :project
  belongs_to :release
  belongs_to :sprint
  belongs_to :component
  belongs_to :category
  belongs_to :user
  has_many :activities, :dependent => :destroy
  
  acts_as_versioned :if => :save_version?
  
  class << self
    def versioned_columns
      @versioned_columns ||= columns.select{|c| %w(sprint_id estimated).include? c.name }
    end
    
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
    
    def find_every_with_at_scope(*args)
      if at = args.last.try(:delete, :at)
        with_at(at) do
          find_every_without_at_scope(*args).select do |ticket|
            ticket.revert_to(ticket.versions.last) if ticket.versions.last
          end
        end
      else
        find_every_without_at_scope *args
      end
    end
    alias_method_chain :find_every, :at_scope
    
    def with_at(at, &block)
      conditions = ["#{versioned_table_name}.updated_at <= ?", at]
      with_scope({:find => {:conditions => conditions, :include => :versions}}, :merge, &block)
    end

    def validate_find_options_with_at_scope(options)
      validate_find_options_without_at_scope options.except(:at)
    end
    alias_method_chain :validate_find_options, :at_scope
  end
  
  def update_attributes(attributes)
    sprint_id, sprint = attributes.values_at :sprint_id, :sprint
    if sprint_id or sprint
      sprint ||= Sprint.find(sprint_id)
      attributes[:release_id] = sprint ? sprint.release_id : nil
    end
    super
  end
  
  def lighthouse_url
    "http://artweb-design.lighthouseapp.com/projects/#{project.remote_id}/tickets/#{remote_id}"
  end
  
  def number_and_title
    "##{remote_id} - #{title}"
  end
  
  def activity_minutes(from_day = nil, to_day = nil)
    acts = from_day.nil? ? activities : activities_in_range(from_day, to_day)
    acts.map(&:total_minutes).compact.sum
  end
  
  def activities_in_range(from_day, to_day = nil)
    range = from_day..(to_day || from_day)
    activities.select{|a| range.include? a.date }
  end
  
  def actual_hours(*period)
    minutes = activity_minutes *period
    minutes.to_f / 60
  end
  
  def actual_at(day)
    (sprint.start_at..day).map{|d| actual_hours(d) }.sum
  end
  
  def estimated_at(day)
    versions = self.current_sprint_versions_at(day, :order => 'id DESC')
#    versions = self.versions.all(:order => 'id DESC')
    versions.each{|v| return v.estimated.to_f if v.created_at.to_date <= day }
    versions.first ? versions.first.estimated.to_f : 0
  end
  
  def current_sprint_versions_at(day, options = {})
    versions.all options.update(:conditions => ['sprint_id = ? AND DATE(updated_at) <= ?', sprint_id, day])
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
      self.send "#{type.name.underscore}=", Milestone.find_by_remote_id(milestone.id)
    end
  
    def set_remote_user(assigned_user_id)
      self.user = User.find_by_remote_id(assigned_user_id) if assigned_user_id
    end
    
    def save_version?
      (sprint_id_changed? or estimated_changed?) and sprint_running?
    end
    
    def sprint_running?
      sprint and sprint.running?
    end
end