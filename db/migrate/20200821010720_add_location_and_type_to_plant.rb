class AddLocationAndTypeToPlant < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :location, :string
    add_column :plants, :type, :string
  end
end
