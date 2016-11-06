class AddBannerToShows < ActiveRecord::Migration[5.0]
  def change
    add_column :shows, :banner, :string
  end
end
