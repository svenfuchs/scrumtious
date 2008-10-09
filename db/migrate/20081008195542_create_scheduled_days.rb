class CreateScheduledDays < ActiveRecord::Migration
  def self.up
    create_table :scheduled_days, :force => true do |t|
      t.references :project
      t.references :user
      t.date :day
      t.integer :hours
    end
  end

  def self.down
    drop_table :scheduled_days
  end
end
