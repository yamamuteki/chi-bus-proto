# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'rexml/document'
require 'objspace'
require 'pp'

def load_bus_stops_and_bus_route_informations
  doc = Nokogiri::XML(open("db/P11-10_12-jgd-g.xml"))
  doc.remove_namespaces!

  point_hash = {}

  doc.css('Point').each do |element|
    point_id = element['id']
    point_hash[point_id] = element.at('pos').text
    print "#{point_id}\r"
  end
  puts

  doc.css('BusStop').each do |element|
    name = element.at('busStopName').text
    gml_id = element['id']
    point_id = element.at('position')['href'].remove '#'
    pos = point_hash[point_id]

    bus_stop = BusStop.create(name: name, gml_id: gml_id, latitude: pos.split[0], longitude: pos.split[1])
    
    element.css('BusRouteInformation').each do |info|
      bus_type = info.at('busType').text.to_i
      operation_company = info.at('busOperationCompany').text
      line_name = info.at('busLineName').text

      bus_route_information = BusRouteInformation.find_or_create_by(bus_type: bus_type, operation_company: operation_company, line_name: line_name)
      bus_route_information.bus_stops << bus_stop
    end
    print "#{gml_id}\r"
  end
  puts
end

def load_bus_route_tracks_and_bus_routes
  doc = Nokogiri::XML(open("db/N07-11_12.xml"))
  doc.remove_namespaces!  

  doc.css('Curve').each do |element|
    curve_id = element['id']
    point_list = element.at('posList').text.strip

    coordinates = []
    point_list.lines do |line|
      line.strip!
      coordinates << {latitude: line.split[0], longitude: line.split[1]}
    end

    BusRouteTrack.create(gml_id: curve_id, coordinates: coordinates)
    print "#{curve_id}\r"
  end
  puts

  doc.css('BusRoute').each do |element|
    gml_id = element['id']
    curve_id = element.at('brt')['href'].remove '#'
    bus_type = element.at('bsc').text.to_i
    operation_company = element.at('boc').text
    line_name = element.at('bln').text
    weekday_rate = element.at('rpd').text
    saturday_rate = element.at('rps').text
    holiday_rate = element.at('rph').text
    note = element.at('rmk').text

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

    bus_route_track = BusRouteTrack.find_by(gml_id: curve_id)
    bus_route.bus_route_tracks << bus_route_track if bus_route_track
    print "#{gml_id}\r"
  end
  puts
end

ActiveRecord::Base.transaction do
  GC::Profiler.enable
  load_bus_stops_and_bus_route_informations
  load_bus_route_tracks_and_bus_routes
  GC::Profiler.report
  pp GC.stat
end
