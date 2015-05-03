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

ActiveRecord::Schema.define(:version => 20130918163119) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "uid"
    t.integer  "plan_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "lock_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "user_id"
    t.string   "campaign"
    t.integer  "impressions_count"
    t.integer  "follows_count"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "fav_counts", :force => true do |t|
    t.string   "tweet_id"
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.integer  "impression_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "impressions", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.string   "to_follow_id"
    t.string   "to_follow_name"
    t.boolean  "followed_back",  :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "account_id"
    t.string   "token"
    t.string   "identifier"
    t.string   "payer_id"
    t.boolean  "completed",  :default => false
    t.boolean  "canceled",   :default => false
    t.boolean  "digital",    :default => true
    t.boolean  "recurring",  :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.float    "amount"
    t.boolean  "popup",      :default => false
    t.integer  "plan_id"
  end

  create_table "plans", :force => true do |t|
    t.string   "title"
    t.float    "price"
    t.text     "summary"
    t.integer  "monthly_impressions", :default => 500
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "access_token"
    t.string   "access_token_secret"
    t.integer  "campaign_count",      :default => 7
    t.string   "profile_image_url"
  end

end
