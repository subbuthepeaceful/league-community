class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.integer :team_id, :null => false
      t.integer :external_id
      t.date :game_date
      t.datetime :game_time
      t.integer :game_slot_id
      t.string :opponent
      t.boolean :is_home_game
      t.string :location
      t.string :status
      t.string :field_duties
      t.string :division
      t.string :league
      t.text :comments
    end
  end

  def down
    drop_table :games
  end
end
