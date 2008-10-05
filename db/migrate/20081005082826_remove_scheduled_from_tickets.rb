class RemoveScheduledFromTickets < ActiveRecord::Migration
  def self.up
    remove_column :tickets, :scheduled
  end

  def self.down
    add_column :tickets, :scheduled, :float
  end
end
