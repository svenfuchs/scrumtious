class RenameActivitiesStartedToStartedAt < ActiveRecord::Migration
  def self.up
    rename_column :activities, :started, :started_at
  end

  def self.down
    rename_column :activities, :started_at, :started
  end
end
