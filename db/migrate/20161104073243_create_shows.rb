class CreateShows < ActiveRecord::Migration[5.0]
  def change
    create_table :shows do |t|
      t.string :tvdb_id
      t.string :name
      t.integer :season
      t.integer :episode

      t.timestamps
    end
  end
end
