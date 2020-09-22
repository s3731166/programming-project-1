class RemoveLightFromPlantRecord < ActiveRecord::Migration[6.0]
  def change
    remove_column :plant_records, :light_recorded, :decimal
    add_column :plant_records, :temp_recorded, :decimal
  end
end
