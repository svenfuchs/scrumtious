# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081005083905) do

  create_table "activities", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.string   "text"
    t.date     "date"
    t.integer  "minutes"
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "stopped_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", :force => true do |t|
    t.integer  "remote_id"
    t.integer  "project_id"
    t.integer  "release_id"
    t.string   "type"
    t.string   "name"
    t.text     "body"
    t.date     "start_at"
    t.date     "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "lighthouse_account"
    t.string   "lighthouse_token"
    t.integer  "remote_id"
    t.string   "name"
    t.text     "body"
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "remote_id"
    t.integer  "parent_id"
    t.integer  "project_id"
    t.integer  "release_id"
    t.integer  "sprint_id"
    t.integer  "category_id"
    t.integer  "component_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.float    "estimated"
    t.float    "actual"
    t.string   "state"
    t.integer  "closed"
    t.integer  "local"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer "remote_id"
    t.string  "name"
  end

end
