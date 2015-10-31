class RemoveBusStopFromBusRouteInformations < ActiveRecord::Migration
  def change
    remove_reference :bus_route_informations, :bus_stop
  end
end
