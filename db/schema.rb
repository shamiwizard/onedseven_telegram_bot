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

ActiveRecord::Schema.define(version: 2020_06_08_105822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "d_masters", force: :cascade do |t|
    t.bigint "person_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_d_masters_on_person_id", unique: true
  end

  create_table "organizers", force: :cascade do |t|
    t.bigint "person_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_organizers_on_person_id", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "telegram_code"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "language_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["telegram_code"], name: "index_people_on_telegram_code"
    t.index ["username"], name: "index_people_on_username"
  end

  add_foreign_key "d_masters", "people"
  add_foreign_key "organizers", "people"
end
