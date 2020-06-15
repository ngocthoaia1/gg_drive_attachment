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

ActiveRecord::Schema.define(version: 2020_06_15_143203) do

  create_table "gg_drive_attachment_attachments", force: :cascade do |t|
    t.string "type"
    t.string "drive_id"
    t.string "drive_backup_id"
    t.string "filename"
    t.string "attachable_type"
    t.integer "attachable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "gg_drive_attachment_attachments_attachable_index"
    t.index ["drive_backup_id"], name: "index_gg_drive_attachment_attachments_on_drive_backup_id"
    t.index ["drive_id"], name: "index_gg_drive_attachment_attachments_on_drive_id"
  end

end
