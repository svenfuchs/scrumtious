class CreateTicketVersions < ActiveRecord::Migration
  def self.up
    add_column :tickets, :version, :integer

    create_table :ticket_versions, :force => true do |t|
      t.references :ticket
      t.integer :version
      t.float :estimated
      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_versions
    remove_column :tickets, :version
  end
end
