class AddChecksToPlants < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :watered, :boolean
    add_column :plants, :sunlight, :boolean
    add_column :plants, :trimmed, :boolean
  end
end
