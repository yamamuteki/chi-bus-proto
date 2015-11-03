# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'
require 'objspace'

ActiveRecord::Base.transaction do

  # Load BusStop & BusRouteInformation
  doc_bus_stops = REXML::Document.new(open("db/P11-10_12-jgd-g.xml"))

  point_hash = {}

  doc_bus_stops.elements.each('ksj:Dataset/gml:Point') do | element |
    puts point_id = element.attributes['gml:id']
    point_hash[point_id] = element.elements['gml:pos'].text
  end

  doc_bus_stops.elements.each('ksj:Dataset/ksj:BusStop') do | element |
    name = element.elements['ksj:busStopName'].text
    puts gml_id = element.attributes['gml:id']
    point_id = element.elements['ksj:position/@xlink:href'].value.remove '#'
    pos = point_hash[point_id]

    bus_stop = BusStop.create(name: name, gml_id: gml_id, latitude: pos.split[0], longitude: pos.split[1] )
    
    element.elements.each('.//ksj:BusRouteInformation') do | info |
      bus_type = info.elements['ksj:busType'].text.to_i
      operation_company = info.elements['ksj:busOperationCompany'].text
      line_name = info.elements['ksj:busLineName'].text

      bus_route_information = BusRouteInformation.find_or_create_by(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
      bus_stop.bus_route_informations << bus_route_information if bus_route_information
    end
  end

  puts "#{ObjectSpace.memsize_of_all} byte"
  doc_bus_stops = nil
  puts "#{ObjectSpace.memsize_of_all} byte"

  # Load BusRouteTrack & BusRoute
  doc_routes = REXML::Document.new(open("db/N07-11_12.xml"))

  doc_routes.elements.each('ksj:Dataset/gml:Curve') do | element |
    puts curve_id = element.attributes['gml:id']
    point_list = element.elements['gml:segments/gml:LineStringSegment/gml:posList'].text.strip

    coordinates = []
    point_list.lines do |line|
      line.strip!
      coordinates << {latitude: line.split[0], longitude: line.split[1]}
    end

    BusRouteTrack.create(gml_id: curve_id, coordinates: coordinates)
  end

  doc_routes.elements.each('ksj:Dataset/ksj:BusRoute') do | element |
    puts gml_id = element.attributes['gml:id']
    bus_type = element.elements['ksj:bsc'].text.to_i
    operation_company = element.elements['ksj:boc'].text
    line_name = element.elements['ksj:bln'].text
    weekday_rate = element.elements['ksj:rpd'].text
    saturday_rate = element.elements['ksj:rps'].text
    holiday_rate = element.elements['ksj:rph'].text
    note = element.elements['ksj:rmk'].text

    bus_route = BusRoute.find_or_create_by(
      bus_type: bus_type,
      operation_company: operation_company,
      line_name: line_name,
      weekday_rate: weekday_rate,
      saturday_rate: saturday_rate,
      holiday_rate: holiday_rate,
      note: note
    )

    bus_route_information = BusRouteInformation.find_by(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
    bus_route_information.bus_route = bus_route if bus_route_information

    curve_id = element.elements['ksj:brt/@xlink:href'].value.remove '#'
    bus_route_track = BusRouteTrack.find_by(gml_id: curve_id)
    bus_route.bus_route_tracks << bus_route_track if bus_route_track
  end
  
  puts "#{ObjectSpace.memsize_of_all} byte"
end
