namespace :chibus do
  desc "Chi-bus utilities"
  task count: :environment do
    puts "BusStop.count", BusStop.count
    puts "BusRouteInformation.count", BusRouteInformation.count
    puts "BusRoute.count", BusRoute.count

    puts "BusRouteInformation.group(:bus_type, :operation_company, :line_name).count", BusRouteInformation.group(:bus_type, :operation_company, :line_name).count.keys.count
    puts "BusRoute.group(:bus_type, :operation_company, :line_name).count", BusRoute.group(:bus_type, :operation_company, :line_name).count.keys.count
  end
end
