class BusStop < ActiveRecord::Base
  has_many :bus_route_informations
end
