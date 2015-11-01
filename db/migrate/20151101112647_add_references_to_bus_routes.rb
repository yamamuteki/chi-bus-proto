class AddReferencesToBusRoutes < ActiveRecord::Migration
  def change
    add_reference :bus_routes, :bus_route_information
  end
end
