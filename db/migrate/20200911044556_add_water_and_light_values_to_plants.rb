class AddWaterAndLightValuesToPlants < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :daily_water, :decimal
    add_column :plants, :daily_light, :decimal
  end
end
