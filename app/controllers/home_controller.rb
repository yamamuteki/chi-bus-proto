class HomeController < ApplicationController
  autocomplete :bus_stop, :name, full: true
  def index
    @bus_stop_search = BusStopSearch.new 
  end
end
