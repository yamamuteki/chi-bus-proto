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

ActiveRecord::Schema.define(version: 20151031101121) do

  create_table "bus_route_informations", force: true do |t|
    t.integer  "bus_type"
    t.string   "operation_company"
    t.string   "line_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bus_route_informations_stops", id: false, force: true do |t|
    t.integer "bus_stop_id"
    t.integer "bus_route_information_id"
  end

  create_table "bus_routes", force: true do |t|
    t.string   "gml_id"
    t.integer  "bus_type"
    t.string   "operation_company"
    t.string   "line_name"
    t.float    "weekday_rate"
    t.float    "saturday_rate"
    t.float    "holiday_rate"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bus_stops", force: true do |t|
    t.string   "gml_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

end
