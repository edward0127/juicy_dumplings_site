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

ActiveRecord::Schema[8.1].define(version: 2026_05_05_112512) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "booking_time", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.text "notes"
    t.integer "party_size", null: false
    t.string "phone"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["booking_time"], name: "index_bookings_on_booking_time"
    t.index ["status"], name: "index_bookings_on_status"
  end

  create_table "business_settings", force: :cascade do |t|
    t.string "address", default: "261 Blackburn Rd, Doncaster East VIC 3109", null: false
    t.string "business_name", default: "Juicy Dumplings", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "hours_note"
    t.integer "max_bookings_per_slot", default: 8, null: false
    t.boolean "ordering_enabled", default: true, null: false
    t.string "owner_email"
    t.boolean "pay_at_pickup_enabled", default: true, null: false
    t.string "phone"
    t.string "price_range", default: "$$", null: false
    t.integer "slot_interval_minutes", default: 30, null: false
    t.string "suburb", default: "Doncaster East, VIC", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_categories_on_position"
  end

  create_table "menu_items", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "gluten_free", default: false, null: false
    t.string "image_url"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.boolean "spicy", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "vegetarian", default: false, null: false
    t.index ["category_id"], name: "index_menu_items_on_category_id"
    t.index ["position"], name: "index_menu_items_on_position"
  end

  create_table "opening_hours", force: :cascade do |t|
    t.boolean "closed", default: false, null: false
    t.string "closes_at"
    t.datetime "created_at", null: false
    t.integer "day_of_week", null: false
    t.string "opens_at"
    t.datetime "updated_at", null: false
    t.index ["day_of_week"], name: "index_opening_hours_on_day_of_week", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "menu_item_id", null: false
    t.string "notes"
    t.integer "order_id", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "unit_price_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_order_items_on_menu_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_email"
    t.string "customer_name", null: false
    t.string "customer_phone"
    t.string "delivery_address"
    t.text "notes"
    t.integer "order_type", default: 0, null: false
    t.boolean "paid", default: false, null: false
    t.datetime "pickup_time"
    t.string "public_id", null: false
    t.integer "status", default: 0, null: false
    t.string "stripe_session_id"
    t.integer "subtotal_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["pickup_time"], name: "index_orders_on_pickup_time"
    t.index ["public_id"], name: "index_orders_on_public_id", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["stripe_session_id"], name: "index_orders_on_stripe_session_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "menu_items", "categories"
  add_foreign_key "order_items", "menu_items"
  add_foreign_key "order_items", "orders"
end
