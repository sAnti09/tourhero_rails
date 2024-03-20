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

ActiveRecord::Schema[7.1].define(version: 2024_03_20_134411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tour_availabilities", force: :cascade do |t|
    t.date "start_date"
    t.integer "start_time"
    t.date "end_date"
    t.integer "end_time"
    t.integer "recur_type"
    t.integer "recur_frequency"
    t.integer "recur_days", default: [], array: true
    t.integer "recur_month"
    t.date "recur_end_date"
    t.integer "recur_end_occurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tour_id"
    t.index ["tour_id"], name: "index_tour_availabilities_on_tour_id"
  end

  create_table "tours", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
