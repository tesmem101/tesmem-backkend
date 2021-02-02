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

ActiveRecord::Schema.define(version: 20210202215925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "super_category_id"
    t.string "cover"
    t.string "title_ar"
    t.string "width"
    t.string "height"
    t.string "unit"
    t.index ["super_category_id"], name: "index_categories_on_super_category_id"
    t.index ["title"], name: "index_categories_on_title"
  end

  create_table "containers", force: :cascade do |t|
    t.integer "folder_id", null: false
    t.integer "instance_id", null: false
    t.string "instance_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_containers_on_folder_id"
    t.index ["instance_id"], name: "index_containers_on_instance_id"
    t.index ["instance_type"], name: "index_containers_on_instance_type"
  end

  create_table "designers", force: :cascade do |t|
    t.integer "design_id"
    t.integer "category_id"
    t.integer "sub_category_id"
    t.boolean "approved", default: false
    t.boolean "private", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "designs", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.json "styles"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "height"
    t.string "width"
    t.integer "is_trashed", default: 0, null: false
    t.integer "cat_id"
    t.index ["user_id"], name: "design_by_user"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.string "image_type"
    t.string "url"
    t.integer "version", default: 1
    t.string "height"
    t.string "width"
  end

  create_table "stock_tags", force: :cascade do |t|
    t.bigint "stock_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_tags_on_stock_id"
    t.index ["tag_id"], name: "index_stock_tags_on_tag_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sub_category_id", default: 0, null: false
    t.json "json"
    t.string "image"
    t.string "svg"
    t.integer "stocktype", default: 0
    t.json "specs"
    t.string "title_ar"
    t.string "svg_thumb"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title_ar"
    t.index ["title"], name: "index_sub_categories_on_title"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "name_ar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "image", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "is_trashed", default: 0, null: false
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "profile"
    t.integer "identity_provider", default: 0
    t.integer "identity_provider_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "folders", "users"
  add_foreign_key "stock_tags", "stocks"
  add_foreign_key "stock_tags", "tags"
end
