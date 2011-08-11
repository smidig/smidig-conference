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

ActiveRecord::Schema.define(:version => 20110811193211) do

  create_table "comments", :force => true do |t|
    t.integer  "talk_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_displayed"
    t.boolean  "is_a_review"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedback_comments", :force => true do |t|
    t.integer "talk_id"
    t.string  "comment"
  end

  create_table "feedback_votes", :force => true do |t|
    t.integer "talk_id"
    t.integer "feedback_id"
    t.string  "comment"
    t.integer "vote"
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.integer  "registration_id"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "paid_amount"
    t.string   "currency"
    t.string   "registered_by"
  end

  create_table "periods", :force => true do |t|
    t.integer  "time_id"
    t.integer  "scene_id"
    t.integer  "topic_id"
    t.integer  "topic_offset"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "time_of_day"
    t.string   "day"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "user_id"
    t.text     "comments"
    t.decimal  "price"
    t.date     "invoiced_at"
    t.date     "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_earlybird"
    t.boolean  "includes_dinner"
    t.string   "description"
    t.text     "ticket_type"
    t.text     "payment_notification_params"
    t.datetime "payment_complete_at"
    t.decimal  "paid_amount"
    t.text     "payment_reference"
    t.boolean  "registration_complete"
    t.boolean  "manual_payment"
    t.text     "invoice_address"
    t.text     "invoice_description"
    t.boolean  "free_ticket"
    t.string   "completed_by"
    t.boolean  "invoiced"
  end

  create_table "speakers", :force => true do |t|
    t.integer "talk_id"
    t.integer "user_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_talks", :id => false, :force => true do |t|
    t.integer "talk_id"
    t.integer "tag_id"
  end

  create_table "talk_types", :force => true do |t|
    t.string   "name"
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "talks", :force => true do |t|
    t.integer  "topic_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "presenting_naked"
    t.string   "video_url"
    t.integer  "position"
    t.boolean  "submitted"
    t.string   "audience_level"
    t.integer  "votes_count",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_commercial_use"
    t.string   "allow_derivatives"
    t.string   "slide_file_name"
    t.string   "slide_content_type"
    t.integer  "slide_file_size"
    t.datetime "slide_updated_at"
    t.integer  "period_id"
    t.integer  "comments_count"
    t.string   "acceptance_status"
    t.boolean  "email_sent",           :default => false
    t.integer  "sum_of_votes"
    t.integer  "num_of_votes"
    t.integer  "talk_type_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "openid_identifier"
    t.string   "email",                                      :null => false
    t.string   "crypted_password",                           :null => false
    t.string   "password_salt",                              :null => false
    t.string   "persistence_token",                          :null => false
    t.string   "name"
    t.string   "company"
    t.string   "phone_number"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "login_count",                 :default => 0, :null => false
    t.integer  "failed_login_count",          :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "is_admin"
    t.string   "perishable_token"
    t.string   "registration_ip"
    t.boolean  "accepted_privacy_guidelines"
    t.boolean  "accept_optional_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "talk_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
