class CreateBusRouteInformations < ActiveRecord::Migration
  def change
    create_table :bus_route_informations do |t|
      t.integer :bus_type
      t.string :operation_company
      t.string :line_name
      t.references :bus_stop

      t.timestamps
    end
  end
end
