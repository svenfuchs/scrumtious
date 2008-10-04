class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :lighthouse_account
      t.string :lighthouse_token
      t.integer :remote_id
      t.string :name
      t.text :body
      t.datetime :synced_at
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
