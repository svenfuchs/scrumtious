class Milestone < ActiveRecord::Base
  belongs_to :project
  
  class << self
    def sync_from_remote_milestone!(project, remote_milestone)
      type = remote_milestone.title =~ /sprint/i ? 'Sprint' : 'Release'
      milestone = find_or_initialize_by_type_and_remote_id type, remote_milestone.id
      milestone.name = remote_milestone.title.gsub(/(sprint|release)\s*/i, '')
      milestone.end_at = remote_milestone.due_on + 1.day
      milestone.project = project
      milestone.save!
    end
  end
end