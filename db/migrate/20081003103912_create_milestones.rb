class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :remote_id
      t.references :project
      t.references :release
      t.string :type
      t.string :name
      t.text :body
      t.date :start_at
      t.date :end_at
      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
