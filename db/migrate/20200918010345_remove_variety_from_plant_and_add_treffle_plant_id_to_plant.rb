class RemoveVarietyFromPlantAndAddTrefflePlantIdToPlant < ActiveRecord::Migration[6.0]
  def change
    # We didn't didly with this
    remove_column :plants, :variety, :string
    # Keeps the trffle.io plant ID for future reference
    # Better than relying on search everytime
    add_column :plants, :treffleID, :integer
  end
end