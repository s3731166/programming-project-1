class RenamePasswordToPasswordDigest < ActiveRecord::Migration[6.0]
  #rails default hasing uses password_digest field as default
  def change
    rename_column :users, :password, :password_digest
  end
end
