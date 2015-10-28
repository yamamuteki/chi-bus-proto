class BusStopsController < ApplicationController
  def index
    like = params[:name].blank? ? "" : "%#{params[:name]}%"
    @bus_stops = BusStop.where('name like ?', like).limit(100).includes(:bus_route_informations)
    respond_to do | format |
      format.html { render :layout => nil }
      format.json { render json: @bus_stops }
    end
  end
end
