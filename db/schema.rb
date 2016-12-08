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

ActiveRecord::Schema.define(version: 20161208173810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_invites_on_project_id", using: :btree
    t.index ["user_id"], name: "index_project_invites_on_user_id", using: :btree
  end

  create_table "project_owners", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_owners_on_project_id", using: :btree
    t.index ["user_id"], name: "index_project_owners_on_user_id", using: :btree
  end

  create_table "project_reviews", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_reviews_on_project_id", using: :btree
    t.index ["review_id"], name: "index_project_reviews_on_review_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "link"
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "helpful"
    t.string   "explanation"
  end

  create_table "review_ratings", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "rating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rating_id"], name: "index_review_ratings_on_rating_id", using: :btree
    t.index ["review_id"], name: "index_review_ratings_on_review_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rating_id"], name: "index_user_ratings_on_rating_id", using: :btree
    t.index ["user_id"], name: "index_user_ratings_on_user_id", using: :btree
  end

  create_table "user_reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_user_reviews_on_review_id", using: :btree
    t.index ["user_id"], name: "index_user_reviews_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uid"
  end

  add_foreign_key "project_invites", "projects"
  add_foreign_key "project_invites", "users"
  add_foreign_key "project_owners", "projects"
  add_foreign_key "project_owners", "users"
  add_foreign_key "project_reviews", "projects"
  add_foreign_key "project_reviews", "reviews"
  add_foreign_key "review_ratings", "ratings"
  add_foreign_key "review_ratings", "reviews"
  add_foreign_key "user_ratings", "ratings"
  add_foreign_key "user_ratings", "users"
  add_foreign_key "user_reviews", "reviews"
  add_foreign_key "user_reviews", "users"
end
