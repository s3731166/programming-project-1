class AddPlantMaintananceValuesToPlant < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :water_level, :decimal
    add_column :plants, :sun_level, :decimal
  end
end
