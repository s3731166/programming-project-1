class CreatePlantRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :plant_records do |t|
      t.decimal :light_recorded
      t.decimal :water_recorded

      t.timestamps
    end
  end
end
