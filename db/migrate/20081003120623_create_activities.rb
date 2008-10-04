class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.references :ticket
      t.references :user
      t.string :text
      t.date :date
      t.integer :minutes
      t.datetime :started
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
