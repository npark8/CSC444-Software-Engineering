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

ActiveRecord::Schema.define(version: 2018_12_02_021333) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "blockees", force: :cascade do |t|
    t.integer "blockee_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockee_id", "user_id"], name: "index_blockees_on_blockee_id_and_user_id"
    t.index ["user_id"], name: "index_blockees_on_user_id"
  end

  create_table "borrowed_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "due_date"
    t.datetime "returned_on"
    t.datetime "temp_due_date"
    t.string "approved"
    t.index ["item_id"], name: "index_borrowed_items_on_item_id"
    t.index ["user_id"], name: "index_borrowed_items_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.string "friendable_type"
    t.integer "friendable_id"
    t.integer "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "blocker_id"
    t.integer "status"
  end

  create_table "item_transactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "returned_on"
    t.datetime "pick_up"
    t.datetime "due_date"
    t.string "user_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "other_user_id"
    t.integer "review_borrower_id"
    t.integer "review_lender_and_item_id"
    t.index ["item_id"], name: "index_item_transactions_on_item_id"
    t.index ["review_borrower_id"], name: "index_item_transactions_on_review_borrower_id"
    t.index ["review_lender_and_item_id"], name: "index_item_transactions_on_review_lender_and_item_id"
    t.index ["user_id"], name: "index_item_transactions_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.text "descr"
    t.string "status", default: "available", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.text "address"
    t.float "latitude"
    t.float "longitude"
    t.string "country"
    t.string "city"
    t.string "street"
    t.boolean "disable", default: false
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "conversation_id"
    t.integer "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "i_due_alert", default: true
    t.boolean "i_req_by_others", default: true
    t.boolean "i_req_approval_alert", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "on_hold_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "req_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "approved", default: "pending", null: false
    t.datetime "due_date"
    t.index ["item_id"], name: "index_on_hold_items_on_item_id"
    t.index ["user_id"], name: "index_on_hold_items_on_user_id"
  end

  create_table "report_users", force: :cascade do |t|
    t.integer "reporter_id"
    t.integer "reportee_id"
    t.text "reason"
    t.text "comment"
  end

  create_table "review_borrowers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "borrower_id"
    t.index ["item_id"], name: "index_review_borrowers_on_item_id"
    t.index ["user_id"], name: "index_review_borrowers_on_user_id"
  end

  create_table "review_lender_and_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lender_id"
    t.index ["item_id"], name: "index_review_lender_and_items_on_item_id"
    t.index ["user_id"], name: "index_review_lender_and_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "fname", null: false
    t.string "lname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "category"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string "phonenum"
    t.string "address"
    t.string "provider"
    t.string "uid"
    t.float "rating"
    t.boolean "disable", default: false
    t.boolean "admin", default: false
  end

  create_table "wish_lists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_wish_lists_on_item_id"
    t.index ["user_id"], name: "index_wish_lists_on_user_id"
  end

end
