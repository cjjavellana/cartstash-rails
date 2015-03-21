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

ActiveRecord::Schema.define(version: 20150321132524) do

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.decimal  "price",              precision: 10, scale: 2
    t.decimal  "promo_price",        precision: 10, scale: 2
    t.string   "tags"
    t.string   "cs_sku"
    t.string   "slug"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id"

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
