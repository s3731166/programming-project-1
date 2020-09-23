class RenameTrimmedToRelocated < ActiveRecord::Migration[6.0]
  def change
    # Rather than asking if their plant has been trimmed
    # Ask if the plant has been relocacted inside/outside based on its :outside value
    rename_column :plants, :trimmed, :relocated
  end
end
