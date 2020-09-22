class ChangeSunLevelToSunTimeInPlants < ActiveRecord::Migration[6.0]
  def change
    rename_column :plants, :sun_level, :sun_time
  end
end
