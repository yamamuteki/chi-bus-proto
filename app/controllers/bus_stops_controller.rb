class BusStopsController < ApplicationController
  autocomplete :bus_stop, :name, full: true
  def index
    @bus_stop_search = BusStopSearch.new(params[:bus_stop_search])

    if @bus_stop_search.valid? then
      like = "%#{@bus_stop_search.keyword}%"
      @bus_stops = BusStop.where('name like ?', like).limit(10).includes(bus_route_informations: [:bus_stops, bus_route: [:bus_route_tracks]])
      respond_to do | format |
        format.html { render :layout => nil }
        format.json { render json: @bus_stops }
      end
    else
      render nothing: true, status: 422
    end
  end
end
