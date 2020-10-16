class AddSpeciesToPlant < ActiveRecord::Migration[6.0]
  def change
    add_column :plants, :species, :string
  end
end
