class AddColumnToBusStop < ActiveRecord::Migration
  def change
    add_column :bus_stops, :latitude, :float
    add_column :bus_stops, :longitude, :float
  end
end
