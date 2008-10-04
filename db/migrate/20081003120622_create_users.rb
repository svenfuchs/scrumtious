class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :remote_id
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end
