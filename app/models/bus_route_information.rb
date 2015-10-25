class BusRouteInformation < ActiveRecord::Base
  belongs_to :bus_stop
  enum bus_type: { private_bus: 1, public_bus: 2, community_bus: 3, demand_bus: 4, other: 5 }
end
