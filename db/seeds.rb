# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'

doc = REXML::Document.new(open("db/P11-10_12-jgd-g.xml"))

doc.elements.each('ksj:Dataset/ksj:BusStop') do | element |

  name = element.elements['ksj:busStopName'].text
  gml_id = element.attributes['gml:id']
  bus_stop = BusStop.create(name: name, gml_id: gml_id)
  
  element.elements.each('.//ksj:BusRouteInformation') do | info |
    bus_type = info.elements['ksj:busType'].text.to_i
    operation_company = info.elements['ksj:busOperationCompany'].text
    line_name = info.elements['ksj:busLineName'].text
    bus_stop.bus_route_informations.create(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
  end

end