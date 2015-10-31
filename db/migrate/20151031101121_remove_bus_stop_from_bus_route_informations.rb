class RemoveBusStopFromBusRouteInformations < ActiveRecord::Migration
  def change
    remove_reference :bus_Route_informations, :bus_stop
  end
end
