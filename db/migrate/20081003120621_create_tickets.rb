class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :remote_id
      t.references :parent
      t.references :project
      t.references :release
      t.references :sprint
      t.references :category
      t.references :component
      t.references :user
      t.string :title
      t.text :body
      t.float :scheduled
      t.float :estimated
      t.float :actual
      t.string :state
      t.integer :closed
      t.integer :local
      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
