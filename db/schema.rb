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

ActiveRecord::Schema.define(version: 2020_12_17_193329) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "scripts", force: :cascade do |t|
    t.bigint "store_id"
    t.string "name"
    t.string "pages"
    t.string "location"
    t.boolean "status", default: false
    t.string "uuid"
    t.string "api_client_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_id"], name: "index_scripts_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "store_hash"
    t.string "access_token"
    t.text "scope"
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "property_id"
    t.boolean "enabled_scripts", default: false
  end

end
