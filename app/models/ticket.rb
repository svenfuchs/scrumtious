class Ticket < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Ticket'
  belongs_to :project
  belongs_to :release
  belongs_to :sprint
  belongs_to :component
  belongs_to :category
  belongs_to :user
  
  class << self
    def states
      [:new, :open, :resolved, :hold, :invalid]
    end
  end

  has_many :activities, :dependent => :destroy do
    def in_range(from_day, to_day = nil)
      return self.to_a if from_day.nil?
      range = from_day..(to_day || from_day)
      self.select{|a| range.include? a.date }
    end
  
    def total(from_day = nil, to_day = nil)
      in_range(from_day, to_day).map(&:total_minutes).compact.sum.to_f
    end
  end
  
  acts_as_versioned :if => :save_version?
  
  class << self
    def versioned_columns
      @versioned_columns ||= columns.select{|c| %w(sprint_id estimated).include? c.name }
    end
    
    def find_every_with_time_range(*args)
      if to = args.last.try(:delete, :to)
        with_time_range(args.last.try(:delete, :from), to) do
          find_every_without_time_range(*args).select do |ticket|
            ticket.revert_to(ticket.versions.last) if ticket.versions.last
          end
        end
      else
        find_every_without_time_range *args
      end
    end
    alias_method_chain :find_every, :time_range
    
    def with_time_range(from, to, &block)
      c = from && to ? ["DATE(#{versioned_table_name}.updated_at) BETWEEN ? AND ?", from, to] :
                       ["DATE(#{versioned_table_name}.updated_at) <= ?", to]
      with_scope({:find => {:conditions => c, :include => :versions}}, :merge, &block)
    end

    def validate_find_options_with_time_range(options)
      validate_find_options_without_time_range options.except(:from, :to)
    end
    alias_method_chain :validate_find_options, :time_range
  end

  def remote_user_id
    user.try(:remote_id)
  end
  
  def remote_milestone_id
    milestone = sprint ? sprint : release
    milestone.try(:remote_id)
  end
  
  def update_attributes(attributes)
    sprint_id, sprint = attributes.values_at :sprint_id, :sprint
    if !sprint_id.blank? or sprint
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
  
  def estimated_at(day)
    versions = self.versions_at(day, :order => 'id DESC')
    versions.each{|v| return v.estimated.to_f if v.created_at.to_date <= day }
    versions.first ? versions.first.estimated.to_f : 0
  end
  
  def versions_at(day, options = {})
    versions.all options.update(:conditions => ['DATE(updated_at) <= ?', day])
  end
  
  def children
    self.class.find_by_parent_id self.id
  end
  
  def to_params
    attributes.slice 'remote_id', 'title', 'project_id', 'release_id', 'sprint_id', 'category_id', 'component_id', 'state'
  end
  
  def push!
    project.synchronizer.push! self unless local?
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