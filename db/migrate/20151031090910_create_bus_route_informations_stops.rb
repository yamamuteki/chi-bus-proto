class CreateBusRouteInformationsStops < ActiveRecord::Migration
  def change
    create_table :bus_route_informations_stops, id: false do |t|
      t.belongs_to :bus_stop
      t.belongs_to :bus_route_information
    end
  end
end
