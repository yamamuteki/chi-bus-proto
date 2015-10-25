# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rexml/document'

doc = REXML::Document.new(open("db/P11-10_12-jgd-g.xml"))

doc.elements.each('ksj:Dataset/ksj:BusStop') do |element|
  name = element.elements['ksj:busStopName'].text
  gml_id = element.attributes['gml:id']
  BusStop.create(name: name, gml_id: gml_id)
end