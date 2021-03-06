# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140413002901) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "age_groups", :force => true do |t|
    t.string  "name",                               :null => false
    t.string  "team_size",                          :null => false
    t.integer "game_slot_duration", :default => 75
  end

  create_table "age_groups_fields", :id => false, :force => true do |t|
    t.integer "age_group_id", :null => false
    t.integer "field_id",     :null => false
  end

  create_table "authorized_users", :force => true do |t|
    t.string "first_name", :null => false
    t.string "last_name",  :null => false
    t.string "email",      :null => false
  end

  create_table "authorized_users_teams", :id => false, :force => true do |t|
    t.integer "authorized_user_id", :null => false
    t.integer "team_id",            :null => false
  end

  create_table "clubs", :force => true do |t|
    t.string "name"
    t.string "tagline"
  end

  create_table "divisions", :force => true do |t|
    t.string "name"
  end

  create_table "fields", :force => true do |t|
    t.string "name",         :null => false
    t.string "location"
    t.string "address",      :null => false
    t.text   "instructions"
  end

  create_table "game_reports", :force => true do |t|
    t.integer "game_id",         :null => false
    t.integer "user_id",         :null => false
    t.string  "home_or_away"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.text    "comments"
  end

  create_table "game_slot_patterns", :force => true do |t|
    t.string  "day_of_the_week",                                    :null => false
    t.time    "first_game_time", :default => '2000-01-01 16:00:00'
    t.time    "last_game_time",  :default => '2000-01-01 02:00:00'
    t.integer "duration",        :default => 75
  end

  create_table "game_slots", :force => true do |t|
    t.integer  "field_id",       :null => false
    t.datetime "game_date_time"
  end

  create_table "games", :force => true do |t|
    t.date     "game_date"
    t.datetime "game_time"
    t.string   "location"
    t.string   "status"
    t.string   "field_duties"
    t.string   "division"
    t.string   "league"
    t.text     "comments"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
  end

  create_table "leagues", :force => true do |t|
    t.string "name"
    t.string "url"
  end

  create_table "player_statistics", :force => true do |t|
    t.integer "game_report_id",  :null => false
    t.integer "player_id",       :null => false
    t.float   "innings_pitched"
    t.integer "pitch_count"
    t.float   "innings_caught"
    t.boolean "all_star_vote"
  end

  create_table "players", :force => true do |t|
    t.integer "team_id"
    t.string  "first_name",    :null => false
    t.string  "last_name",     :null => false
    t.string  "jersey_number"
  end

  create_table "roles", :force => true do |t|
    t.integer "user_id",                        :null => false
    t.integer "team_id",                        :null => false
    t.string  "name",    :default => "Manager"
  end

  create_table "seasons", :force => true do |t|
    t.string "name",       :null => false
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "teams", :force => true do |t|
    t.string  "name",         :null => false
    t.string  "gender"
    t.string  "external_url"
    t.integer "division_id",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "superadmin",             :default => false, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
