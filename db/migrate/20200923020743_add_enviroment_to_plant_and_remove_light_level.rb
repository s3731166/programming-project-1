class AddEnviromentToPlantAndRemoveLightLevel < ActiveRecord::Migration[6.0]
  def change
    # To be interpreted into as an outside boolean (false is inside) via a range
    # Old merges of work included sun_time and water_level and so must be removed
    remove_column :plants, :daily_light, :decimal
    remove_column :plants, :sun_time, :decimal
    remove_column :plants, :water_level, :decimal
    add_column :plants, :outside, :boolean
  end
end
