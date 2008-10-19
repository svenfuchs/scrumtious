class AddSprintIdToTicketVersions < ActiveRecord::Migration
  def self.up
    add_column :ticket_versions, :sprint_id, :integer
    
    Ticket.all.each do |ticket|
      next unless ticket.sprint_id
      Ticket::Version.update_all "sprint_id = #{ticket.sprint_id}", "ticket_id = #{ticket.id}"
    end
  end

  def self.down
    remove_column :ticket_versions, :sprint_id
  end
end
