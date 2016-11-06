class AddIndexToShowsTvdbId < ActiveRecord::Migration[5.0]
  def change
    add_index :shows, :tvdb_id, unique: true
  end
end
