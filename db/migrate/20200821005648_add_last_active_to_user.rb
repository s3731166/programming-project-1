class AddLastActiveToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_active, :datetime
  end
end
