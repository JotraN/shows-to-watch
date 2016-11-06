class AddCompletedToShows < ActiveRecord::Migration[5.0]
  def change
    add_column :shows, :completed, :boolean, default: false
  end
end
