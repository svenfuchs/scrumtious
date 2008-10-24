class AddRemoteInstances < ActiveRecord::Migration
  def self.up
    create_table :remote_instances, :force => true do |t|
      t.references :project
      t.references :local, :polymorphic => true
      t.integer :remote_id
    end
  end

  def self.down
    drop_table :remote_instances
  end
end
