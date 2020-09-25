class AddMinAndMaxTemperatureToPlant < ActiveRecord::Migration[6.0]
  def change
    # Min and max temps for plant
    # Not critical, but accepted to use in forecasting danger
    add_column :plants, :max_temp, :decimal
    add_column :plants, :min_temp, :decimal
  end
end
