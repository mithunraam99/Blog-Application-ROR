class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :bookmarks, :articles_id, :article_id
    rename_column :bookmarks, :users_id, :user_id
  end
end
