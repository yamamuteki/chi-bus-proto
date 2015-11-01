namespace :chibus do
  desc "Count the database record"
  task count: :environment do
    puts "BusStop.count", BusStop.count
    puts "BusRouteInformation.count", BusRouteInformation.count
    puts "BusRoute.count", BusRoute.count
    puts "BusRouteInformationStop.count", ActiveRecord::Base.connection.select_one("select count(*) from bus_route_informations_stops")

    puts "BusRouteInformation.group(:bus_type, :operation_company, :line_name).count", BusRouteInformation.group(:bus_type, :operation_company, :line_name).count.keys.count
    puts "BusRoute.group(:bus_type, :operation_company, :line_name, :weekday_rate, :saturday_rate, :holiday_rate).count", BusRoute.group(:bus_type, :operation_company, :line_name, :weekday_rate, :saturday_rate, :holiday_rate).count.keys.count

    puts "BusRoute.where(bus_route_information: nil).count", BusRoute.where(bus_route_information: nil).count
    puts "BusRoute.where.not(bus_route_information: nil).count", BusRoute.where.not(bus_route_information: nil).count
  end
end

desc "Chi-bus utilities"
task chibus: "chibus:count"