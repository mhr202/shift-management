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

ActiveRecord::Schema[7.0].define(version: 2022_12_20_173712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shifts", force: :cascade do |t|
    t.string "shift_type", null: false
    t.date "day", null: false
    t.bigint "worker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day", "worker_id"], name: "index_shifts_on_day_and_worker_id", unique: true
    t.index ["worker_id"], name: "index_shifts_on_worker_id"
  end

  create_table "workers", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_workers_on_email", unique: true
  end

  add_foreign_key "shifts", "workers"
end
