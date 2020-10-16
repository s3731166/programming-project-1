class AddOptingBooleansToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :recieve_texts, :boolean
    add_column :users, :competitive, :boolean
  end
end
