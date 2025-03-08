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

ActiveRecord::Schema[8.0].define(version: 2025_05_16_015151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "gtin"
    t.string "gtin_encoding"
    t.string "name"
    t.string "brand_name"
    t.jsonb "properties", default: {}
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "linked_data", default: {}
    t.index "to_tsvector('english'::regconfig, (brand_name)::text)", name: "products_brand_name_full_text_index", using: :gin
    t.index "to_tsvector('english'::regconfig, (name)::text)", name: "products_name_full_text_index", using: :gin
    t.index "to_tsvector('english'::regconfig, linked_data)", name: "products_linked_data_full_text_index", using: :gin
    t.index "to_tsvector('english'::regconfig, properties)", name: "products_properties_full_text_index", using: :gin
    t.index ["brand_name"], name: "index_products_on_brand_name"
    t.index ["gtin"], name: "index_products_on_gtin", unique: true
    t.index ["linked_data"], name: "index_products_on_linked_data", using: :gin
    t.index ["name"], name: "index_products_on_name"
    t.index ["properties"], name: "index_products_on_properties"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
end
