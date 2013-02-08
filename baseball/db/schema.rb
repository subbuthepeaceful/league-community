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

ActiveRecord::Schema.define(:version => 20110326132415) do

  create_table "addresses", :force => true do |t|
    t.string  "street_address"
    t.string  "city"
    t.string  "state",          :limit => 8
    t.string  "zip_code",       :limit => 12
    t.integer "contact_id"
  end

  create_table "admin_roles", :force => true do |t|
    t.integer "contact_id",           :null => false
    t.string  "admin_classification"
    t.integer "admin_instance"
    t.string  "role_title"
  end

  create_table "availabilities", :force => true do |t|
    t.integer  "game_id",        :null => false
    t.integer  "participant_id", :null => false
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circle_options", :force => true do |t|
    t.integer  "hub_id",       :null => false
    t.string   "option_name"
    t.string   "option_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circles_messages", :force => true do |t|
    t.integer  "contact_id",  :null => false
    t.string   "subject"
    t.text     "body"
    t.datetime "sent"
    t.boolean  "important"
    t.integer  "in_reply_to"
  end

  create_table "contacts", :force => true do |t|
    t.string   "title",                     :limit => 8
    t.string   "first_name",                :limit => 24
    t.string   "last_name",                 :limit => 24
    t.string   "email_address",             :limit => 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_tye"
    t.integer  "profile_photo_file_size"
  end

  create_table "contacts_participants", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "participant_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "divisions", :force => true do |t|
    t.string  "name"
    t.string  "age_range"
    t.integer "program_id",                         :null => false
    t.text    "description"
    t.string  "team_prefix"
    t.boolean "has_schedule",    :default => false
    t.boolean "external",        :default => false
    t.integer "preseason_games", :default => 0
  end

  create_table "events", :force => true do |t|
    t.string   "name",        :default => "", :null => false
    t.text     "description"
    t.datetime "starts"
    t.datetime "ends"
    t.integer  "location_id"
    t.integer  "session_id"
    t.integer  "division_id"
  end

  create_table "game_reports", :force => true do |t|
    t.integer  "contact_id",         :null => false
    t.integer  "team_id",            :null => false
    t.integer  "game_id",            :null => false
    t.datetime "actual_start_date"
    t.datetime "actual_start_time"
    t.datetime "actual_end_time"
    t.integer  "home_team_score"
    t.integer  "away_team_score"
    t.integer  "num_innings_played"
    t.string   "end_reason"
    t.string   "plate_umpire"
    t.string   "field_umpire"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
  end

  create_table "game_statistics", :force => true do |t|
    t.integer "game_report_id",  :null => false
    t.integer "participant_id",  :null => false
    t.string  "statistic_name"
    t.string  "statistic_value"
  end

  create_table "games", :force => true do |t|
    t.integer  "division_id",                           :null => false
    t.datetime "scheduled_at"
    t.text     "notes"
    t.integer  "snack_volunteer_id"
    t.integer  "location_id"
    t.boolean  "external",           :default => false
  end

  create_table "hub_assets", :force => true do |t|
    t.integer  "hub_id",     :null => false
    t.string   "name"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hubs", :force => true do |t|
    t.string   "name",                :default => "",    :null => false
    t.string   "url_prefix",          :default => "",    :null => false
    t.text     "description"
    t.integer  "parent_id"
    t.string   "time_zone",           :default => "UTC"
    t.datetime "active_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "home_url"
    t.string   "sponsor_email"
    t.string   "circle_name"
    t.string   "program_variant"
    t.string   "full_circles_domain"
    t.string   "tax_id"
    t.string   "from_email"
  end

  create_table "hubs_participants", :id => false, :force => true do |t|
    t.integer "hub_id"
    t.integer "participant_id"
  end

  create_table "locations", :force => true do |t|
    t.integer "hub_id",                                       :null => false
    t.string  "name",                         :default => "", :null => false
    t.string  "street_address"
    t.string  "city"
    t.string  "state",          :limit => 8
    t.string  "zip_code",       :limit => 12
    t.text    "comments"
  end

  create_table "mailbox_messages", :id => false, :force => true do |t|
    t.integer "mailbox_id",                           :null => false
    t.integer "circles_message_id",                   :null => false
    t.boolean "unread",             :default => true
  end

  create_table "mailboxes", :force => true do |t|
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matchups", :force => true do |t|
    t.integer "game_id",            :null => false
    t.integer "team_id",            :null => false
    t.string  "home_or_away"
    t.integer "snack_volunteer_id"
  end

  create_table "participants", :force => true do |t|
    t.string   "title",                     :limit => 8
    t.string   "first_name",                :limit => 24
    t.string   "last_name",                 :limit => 24
    t.datetime "date_of_birth"
    t.datetime "member_since"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_tye"
    t.integer  "profile_photo_file_size"
  end

  create_table "phones", :force => true do |t|
    t.string  "phone_number"
    t.string  "phone_type"
    t.boolean "preferred",    :default => false
    t.integer "contact_id"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "participant_id"
    t.integer  "team_id"
    t.string   "source"
    t.string   "source_user_id"
    t.string   "source_album_id"
    t.string   "source_photo_id"
    t.string   "title"
    t.string   "description",       :limit => 1024
    t.string   "thumbnail_url",     :limit => 512
    t.string   "photo_url",         :limit => 512
    t.datetime "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_tye"
    t.integer  "image_file_size"
  end

  create_table "programs", :force => true do |t|
    t.integer  "hub_id",                            :null => false
    t.string   "name"
    t.text     "description"
    t.string   "status",      :default => "Active"
    t.datetime "created_on"
    t.string   "created_by"
    t.integer  "parent_id"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "session_id"
    t.integer  "division_id"
    t.datetime "registered_date"
    t.text     "registration_requests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.integer  "program_id",                        :null => false
    t.string   "name",        :default => "",       :null => false
    t.string   "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status",      :default => "Active"
  end

  create_table "sponsored_options", :force => true do |t|
    t.integer "sponsor_id"
    t.integer "sponsorship_option_id"
    t.integer "amount"
    t.text    "additional_info"
    t.string  "status"
    t.string  "payment_reference"
  end

  create_table "sponsors", :force => true do |t|
    t.string   "company_name",                       :default => "", :null => false
    t.string   "company_website"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "street_address"
    t.string   "city"
    t.string   "state",                :limit => 8
    t.string   "zip_code",             :limit => 12
    t.string   "banner1_file_name"
    t.string   "banner1_content_type"
    t.integer  "banner1_file_size"
    t.datetime "banner1_updated_at"
    t.string   "banner2_file_name"
    t.string   "banner2_content_type"
    t.integer  "banner2_file_size"
    t.datetime "banner2_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hub_id"
  end

  create_table "sponsorship_options", :force => true do |t|
    t.integer "hub_id"
    t.string  "group"
    t.string  "name"
    t.string  "description"
    t.string  "graphic_file_name"
    t.string  "graphic_file_type"
    t.integer "graphic_file_size"
    t.string  "amount"
    t.boolean "primary"
  end

  create_table "sponsorships", :force => true do |t|
    t.string   "sponsorable_type"
    t.integer  "sponsorable_id"
    t.integer  "sponsor_id"
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "status"
    t.string   "notes",            :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "star_player_votes", :force => true do |t|
    t.integer "participant_id", :null => false
    t.integer "game_report_id", :null => false
    t.integer "vote_rank"
  end

  create_table "team_memberships", :force => true do |t|
    t.integer "participant_id", :null => false
    t.integer "team_id",        :null => false
    t.string  "role"
    t.integer "jersey_number"
  end

  create_table "team_records", :force => true do |t|
    t.integer "team_id",                       :null => false
    t.integer "games_played", :default => 0
    t.integer "wins",         :default => 0
    t.integer "losses",       :default => 0
    t.integer "ties",         :default => 0
    t.float   "win_pct",      :default => 0.0
    t.integer "runs_for",     :default => 0
    t.integer "runs_against", :default => 0
  end

  create_table "teams", :force => true do |t|
    t.string  "name"
    t.integer "division_id"
    t.integer "session_id"
    t.string  "selected_name"
    t.string  "logo_file_name"
    t.string  "logo_content_tye"
    t.integer "logo_file_size"
    t.boolean "is_external",      :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "first_name",                :limit => 24
    t.string   "last_name",                 :limit => 24
    t.boolean  "site_admin",                               :default => false
    t.integer  "contact_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "volunteer_signups", :force => true do |t|
    t.integer "registration_id"
    t.integer "contact_id"
    t.string  "role"
  end

end
