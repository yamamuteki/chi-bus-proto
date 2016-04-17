class RemoveColumnFromBusRoute < ActiveRecord::Migration
  def change
    remove_column :bus_routes, :gml_id, :string
  end
end
