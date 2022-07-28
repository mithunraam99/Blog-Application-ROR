class RenameOldTableToNewTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :active_storage_tables, :active_storage_blobs
  end
end
