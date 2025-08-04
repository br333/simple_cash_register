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

ActiveRecord::Schema[8.0].define(version: 2025_08_04_053148) do
  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity"
    t.integer "promotion_id"
    t.decimal "discount_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["promotion_id"], name: "index_order_items_on_promotion_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "uuid", default: "gen_random_uuid()", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_orders_on_uuid", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
  end

  create_table "promotion_rules", force: :cascade do |t|
    t.integer "promotion_id", null: false
    t.datetime "expiration_date"
    t.float "discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rule_type"
    t.integer "required_items_count"
    t.index ["promotion_id"], name: "index_promotion_rules_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_id"
    t.index ["product_id"], name: "index_promotions_on_product_id"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_items", "promotions"
  add_foreign_key "promotion_rules", "promotions"
  add_foreign_key "promotions", "products"
end
