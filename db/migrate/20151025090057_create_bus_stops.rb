class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :gml_id
      t.string :name

      t.timestamps
    end
  end
end
