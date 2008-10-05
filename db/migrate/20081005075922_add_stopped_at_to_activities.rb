class AddStoppedAtToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :stopped_at, :datetime
  end

  def self.down
    remove_column :activities, :stopped_at
  end
end
