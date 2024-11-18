# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_18_154505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "reservation_time", null: false, comment: "date and time"
    t.integer "duration", default: 1, null: false, comment: "default 1 hr and it will be 2hr, 3hr, etc"
    t.integer "reservation_capacity", null: false
    t.integer "status", default: 0, null: false, comment: "0: confirmed, 1: cancelled, 2: completed, 3: absent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_reservations", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "table_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_table_reservations_on_reservation_id"
    t.index ["table_id"], name: "index_table_reservations_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "capacity", null: false
    t.integer "location", comment: "window, patio, etc but the future feature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "table_reservations", "reservations"
  add_foreign_key "table_reservations", "tables"
end
