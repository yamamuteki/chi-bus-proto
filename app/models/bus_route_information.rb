class BusRouteInformation < ActiveRecord::Base
  belongs_to :bus_stop
  enum bus_type: { private_bus: 1, public_bus: 2, community_bus: 3, demand_bus: 4, other: 5 }

  def bus_type_label
    return "路線バス（民間）" if private_bus?
    return "路線バス（公営）" if public_bus?
    return "コミュニティバス" if community_bus?
    return "デマンドバス" if demand_bus?
    return "その他" if other?
  end
end
