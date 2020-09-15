class AddPlantIdToPlantRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :plant_records, :plant_id, :integer
  end
end
