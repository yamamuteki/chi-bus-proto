class CreateBusRoutes < ActiveRecord::Migration
  def change
    create_table :bus_routes do |t|
      t.string :gml_id
      t.integer :bus_type
      t.string :operation_company
      t.string :line_name
      t.float :weekday_rate
      t.float :saturday_rate
      t.float :holiday_rate
      t.string :note

      t.timestamps
    end
  end
end
