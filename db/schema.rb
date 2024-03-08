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

ActiveRecord::Schema[7.1].define(version: 2024_03_08_022221) do
  create_table "links", force: :cascade do |t|
    t.integer "snapshot_id", null: false
    t.text "sender"
    t.text "receiver"
    t.text "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snapshot_id"], name: "index_links_on_snapshot_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.text "data", limit: 65536
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "links", "snapshots"
end