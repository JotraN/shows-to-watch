class DefaultSeasonEpisodeToShows < ActiveRecord::Migration[5.0]
  def change
    change_column_default :shows, :season, 0
    change_column_default :shows, :episode, 0
  end
end
