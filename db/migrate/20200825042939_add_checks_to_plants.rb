class AddChecksToPlants < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :water_level, :decimal
    add_column :plants, :sun_time, :decimal
    add_column :plants, :trimmed, :boolean
  end
end
