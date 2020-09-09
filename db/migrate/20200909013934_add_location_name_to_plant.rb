class AddLocationNameToPlant < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :locationName, :string
  end
end
