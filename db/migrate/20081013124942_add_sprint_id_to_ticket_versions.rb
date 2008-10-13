class AddSprintIdToTicketVersions < ActiveRecord::Migration
  def self.up
    add_column :ticket_versions, :sprint_id, :integer
  end

  def self.down
    remove_column :ticket_versions, :sprint_id
  end
end
