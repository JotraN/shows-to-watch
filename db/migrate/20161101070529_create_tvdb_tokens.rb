class CreateTvdbTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tvdb_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
