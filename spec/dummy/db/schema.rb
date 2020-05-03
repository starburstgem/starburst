# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_03_191638) do

  create_table "starburst_announcement_views", force: :cascade do |t|
    t.integer "user_id"
    t.integer "announcement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "announcement_id"], name: "starburst_announcement_view_index", unique: true
  end

  create_table "starburst_announcements", force: :cascade do |t|
    t.text "title"
    t.text "body"
    t.datetime "start_delivering_at"
    t.datetime "stop_delivering_at"
    t.text "limit_to_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "category"
  end

  create_table "users", force: :cascade do |t|
    t.string "subscription"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
