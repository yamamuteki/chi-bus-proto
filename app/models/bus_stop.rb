class BusStop < ActiveRecord::Base
  has_and_belongs_to_many :bus_route_informations, -> { order("operation_company, line_name") }
end
