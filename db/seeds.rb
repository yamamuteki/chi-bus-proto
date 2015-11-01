# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'

doc = REXML::Document.new(open("db/P11-10_12-jgd-g.xml"))

hash = {}

doc.elements.each('ksj:Dataset/gml:Point') do | element |
  puts point_id = element.attributes['gml:id']
  hash[point_id] = element.elements['gml:pos'].text
end

bus_route_info_hash = {}

ActiveRecord::Base.transaction do
  doc.elements.each('ksj:Dataset/ksj:BusStop') do | element |
    name = element.elements['ksj:busStopName'].text
    puts gml_id = element.attributes['gml:id']
    point_id = element.elements['ksj:position/@xlink:href'].value.tr '#', ''
    pos = hash[point_id]

    bus_stop = BusStop.create(name: name, gml_id: gml_id, latitude: pos.split[0], longitude: pos.split[1] )
    
    element.elements.each('.//ksj:BusRouteInformation') do | info |
      bus_type = info.elements['ksj:busType'].text.to_i
      operation_company = info.elements['ksj:busOperationCompany'].text
      line_name = info.elements['ksj:busLineName'].text

      bus_route_information = bus_route_info_hash[[bus_type, operation_company, line_name]] || BusRouteInformation.new(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
      bus_route_info_hash[[bus_type, operation_company, line_name]] = bus_route_information

      bus_stop.bus_route_informations << bus_route_information
    end
  end
end

doc_route = REXML::Document.new(open("db/N07-11_12.xml"))

bus_route_hash = {}

ActiveRecord::Base.transaction do
  doc_route.elements.each('ksj:Dataset/ksj:BusRoute') do | element |
    puts gml_id = element.attributes['gml:id']
    bus_type = element.elements['ksj:bsc'].text.to_i
    operation_company = element.elements['ksj:boc'].text
    line_name = element.elements['ksj:bln'].text
    weekday_rate = element.elements['ksj:rpd'].text
    saturday_rate = element.elements['ksj:rps'].text
    holiday_rate = element.elements['ksj:rph'].text
    note = element.elements['ksj:rmk'].text

    bus_route = bus_route_hash[[bus_type, operation_company, line_name]] || 
      BusRoute.create(
        bus_type: bus_type,
        operation_company: operation_company,
        line_name: line_name,
        weekday_rate: weekday_rate,
        saturday_rate: saturday_rate,
        holiday_rate: holiday_rate,
        note: note
      )
    bus_route_hash[[bus_type, operation_company, line_name]] = bus_route

    bus_route_information = bus_route_info_hash[[bus_type, operation_company, line_name]] || BusRouteInformation.new(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
    bus_route_information.bus_route = bus_route if bus_route_information
  end
end
