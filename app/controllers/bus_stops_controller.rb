class BusStopsController < ApplicationController
  def index
    @bus_stop_search = BusStopSearch.new(params[:bus_stop_search])

    if @bus_stop_search.valid? then
      like = "%#{@bus_stop_search.keyword}%"
      @bus_stops = BusStop.where('name like ?', like).limit(100).includes(:bus_route_informations)
      respond_to do | format |
        format.html { render :layout => nil }
        format.json { render json: @bus_stops }
      end
    else
      render nothing: true, status: 422
    end
  end
end
