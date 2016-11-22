class AddAbandonedToShows < ActiveRecord::Migration[5.0]
  def change
    add_column :shows, :abandoned, :boolean, default: false
  end
end
