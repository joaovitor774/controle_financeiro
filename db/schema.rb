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

ActiveRecord::Schema[8.1].define(version: 2026_03_10_145143) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "account_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.bigint "account_type_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.decimal "initial_balance", precision: 12, scale: 2, default: "0.0", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_type_id"], name: "index_accounts_on_account_type_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "category_kind_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["category_kind_id"], name: "index_categories_on_category_kind_id"
    t.index ["user_id", "name"], name: "index_categories_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "category_kinds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.bigint "entry_status_id", null: false
    t.bigint "entry_type_id", null: false
    t.text "notes"
    t.date "occurred_on", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_entries_on_account_id"
    t.index ["category_id"], name: "index_entries_on_category_id"
    t.index ["entry_status_id"], name: "index_entries_on_entry_status_id"
    t.index ["entry_type_id"], name: "index_entries_on_entry_type_id"
    t.index ["occurred_on"], name: "index_entries_on_occurred_on"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "entry_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "entry_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "account_types"
  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "category_kinds"
  add_foreign_key "categories", "users"
  add_foreign_key "entries", "accounts"
  add_foreign_key "entries", "categories"
  add_foreign_key "entries", "entry_statuses"
  add_foreign_key "entries", "entry_types"
  add_foreign_key "entries", "users"
end
