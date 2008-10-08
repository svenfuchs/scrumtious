class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships, :force => true do |t|
      t.references :project
      t.references :user
    end
  end

  def self.down
    drop_table :memberships
  end
end
