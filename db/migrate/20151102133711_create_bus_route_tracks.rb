class CreateBusRouteTracks < ActiveRecord::Migration
  def change
    create_table :bus_route_tracks do |t|
      t.string :gml_id
      t.text :coordinates
      t.references :bus_route

      t.timestamps
    end
  end
end
