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

ActiveRecord::Schema.define(:version => 20081024142257) do

  create_table "activities", :force => true do |t|
    t.integer  "ticket_id",  :limit => 11
    t.integer  "user_id",    :limit => 11
    t.string   "text"
    t.date     "date"
    t.integer  "minutes",    :limit => 11
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "stopped_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "project_id", :limit => 11
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.integer  "project_id", :limit => 11
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer "project_id", :limit => 11
    t.integer "user_id",    :limit => 11
  end

  create_table "milestones", :force => true do |t|
    t.integer  "remote_id",  :limit => 11
    t.integer  "project_id", :limit => 11
    t.integer  "release_id", :limit => 11
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
    t.integer  "remote_id",          :limit => 11
    t.string   "name"
    t.text     "body"
    t.datetime "synced_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remote_instances", :force => true do |t|
    t.integer "project_id"
    t.integer "local_id"
    t.string  "local_type"
    t.integer "remote_id"
  end

  create_table "scheduled_days", :force => true do |t|
    t.integer "project_id", :limit => 11
    t.integer "user_id",    :limit => 11
    t.date    "day"
    t.integer "minutes",    :limit => 11
  end

  create_table "ticket_versions", :force => true do |t|
    t.integer  "ticket_id",  :limit => 11
    t.integer  "version",    :limit => 11
    t.float    "estimated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_id"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "remote_id",    :limit => 11
    t.integer  "parent_id",    :limit => 11
    t.integer  "project_id",   :limit => 11
    t.integer  "release_id",   :limit => 11
    t.integer  "sprint_id",    :limit => 11
    t.integer  "category_id",  :limit => 11
    t.integer  "component_id", :limit => 11
    t.integer  "user_id",      :limit => 11
    t.string   "title"
    t.text     "body"
    t.integer  "estimated"
    t.integer  "actual"
    t.string   "state"
    t.integer  "closed",       :limit => 11
    t.integer  "local",        :limit => 11
    t.integer  "priority",     :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",      :limit => 11
  end

  create_table "users", :force => true do |t|
    t.integer "remote_id", :limit => 11
    t.string  "name"
  end

end
