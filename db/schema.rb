# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150626145541) do

  create_table "countries", force: :cascade do |t|
    t.string   "country_code"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "credit_card_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  create_table "delivery_addresses", force: :cascade do |t|
    t.string   "recipient_name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "country"
    t.string   "contact_no"
    t.string   "alternate_no"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "status"
    t.string   "location_coords"
  end

  add_index "delivery_addresses", ["user_id"], name: "index_delivery_addresses_on_user_id"

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "duration"
    t.datetime "start_date"
    t.string   "expiry_date"
    t.string   "member_id"
    t.decimal  "amount_paid", precision: 10, scale: 2
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "status"
  end

  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "payment_details", force: :cascade do |t|
    t.integer  "payment_id"
    t.string   "name"
    t.string   "sku"
    t.decimal  "price",      precision: 10, scale: 2
    t.decimal  "amount",     precision: 10, scale: 2
    t.float    "quantity"
    t.float    "discount"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "payment_details", ["payment_id"], name: "index_payment_details_on_payment_id"

  create_table "payment_methods", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "credit_card_type"
    t.string   "credit_card_no"
    t.string   "security_code"
    t.string   "expiry_month"
    t.string   "expiry_year"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "country"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "status"
  end

  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id"

  create_table "payments", force: :cascade do |t|
    t.string   "request_ref"
    t.string   "payment_ref"
    t.string   "description"
    t.decimal  "amount",        precision: 10, scale: 2
    t.string   "status"
    t.datetime "cancelled_on"
    t.string   "cancelled_by"
    t.string   "cancel_reason"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "slug"
    t.integer  "product_category_id"
  end

  add_index "product_categories", ["product_category_id"], name: "index_product_categories_on_product_category_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "product_category_id"
    t.string   "image_front"
    t.string   "image_back"
    t.string   "left_image"
    t.string   "right_image"
    t.string   "additional_info"
    t.string   "packaging"
    t.decimal  "price",               precision: 10, scale: 2
    t.decimal  "promo_price",         precision: 10, scale: 2
    t.string   "tags"
    t.string   "cs_sku"
    t.string   "slug"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "uom"
    t.float    "discount"
    t.decimal  "qty",                 precision: 10, scale: 2
    t.decimal  "max_order",           precision: 10, scale: 2
  end

  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id"

  create_table "reserved_items", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.decimal  "qty",        precision: 10, scale: 2
    t.string   "session_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "reserved_items", ["product_id"], name: "index_reserved_items_on_product_id"
  add_index "reserved_items", ["user_id"], name: "index_reserved_items_on_user_id"

  create_table "sales_order_items", force: :cascade do |t|
    t.integer  "sales_order_id"
    t.string   "sku"
    t.string   "name"
    t.float    "quantity"
    t.decimal  "price",          precision: 10, scale: 2
    t.decimal  "total",          precision: 10, scale: 2
    t.string   "status"
    t.string   "remarks"
    t.float    "discount"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "sales_order_items", ["sales_order_id"], name: "index_sales_order_items_on_sales_order_id"

  create_table "sales_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "order_date"
    t.decimal  "order_amount",          precision: 10, scale: 2
    t.string   "payment_type"
    t.integer  "payment_method_id"
    t.datetime "delivery_date"
    t.string   "time_range"
    t.datetime "received_date"
    t.datetime "order_dispatched_date"
    t.string   "remarks"
    t.string   "status"
    t.integer  "delivery_address_id"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.boolean  "paid",                                           default: false
    t.string   "payment_ref"
    t.string   "transaction_ref"
  end

  add_index "sales_orders", ["delivery_address_id"], name: "index_sales_orders_on_delivery_address_id"
  add_index "sales_orders", ["payment_method_id"], name: "index_sales_orders_on_payment_method_id"
  add_index "sales_orders", ["user_id"], name: "index_sales_orders_on_user_id"

  create_table "sequences", force: :cascade do |t|
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "supplier_items", force: :cascade do |t|
    t.string   "supplier_sku"
    t.string   "cartstash_sku"
    t.string   "item_description"
    t.string   "unit_of_measure"
    t.decimal  "item_price",       precision: 10, scale: 2
    t.decimal  "min_order"
    t.string   "remarks"
    t.integer  "supplier_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "item_name"
    t.string   "slug"
  end

  add_index "supplier_items", ["supplier_id"], name: "index_supplier_items_on_supplier_id"

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_no"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "zip"
    t.string   "country"
    t.string   "slug"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "terms_of_service"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_number"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "country"
    t.string   "zip"
    t.string   "invitation_token"
    t.string   "gender"
    t.date     "birthdate"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
