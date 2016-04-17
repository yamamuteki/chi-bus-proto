class HomeController < ApplicationController
  def index
    @bus_stop_search = BusStopSearch.new
  end
end
