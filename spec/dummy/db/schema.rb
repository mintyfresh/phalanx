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

ActiveRecord::Schema[8.1].define(version: 2026_02_16_224810) do
  create_table "phalanx_permission_assignments", force: :cascade do |t|
    t.bigint "assignable_id", null: false
    t.string "assignable_type", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "permission_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["assignable_type", "assignable_id", "permission_id"], name: "idx_on_assignable_type_assignable_id_permission_id_db35db88c3", unique: true
    t.index ["assignable_type", "assignable_id"], name: "index_phalanx_permission_assignments_on_assignable"
    t.index ["permission_id"], name: "index_phalanx_permission_assignments_on_permission_id"
  end

  create_table "role_assignments", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "role_assignable_id", null: false
    t.string "role_assignable_type", null: false
    t.integer "role_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["role_assignable_type", "role_assignable_id"], name: "index_role_assignments_on_role_assignable"
    t.index ["role_id", "role_assignable_type", "role_assignable_id"], name: "idx_on_role_id_role_assignable_type_role_assignable_e2205e613b", unique: true
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "description"
    t.string "name", null: false
    t.boolean "system", default: false, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "role_assignments", "roles"
end
