class CreateGameSlotPatterns < ActiveRecord::Migration
  def up
    create_table :game_slot_patterns do |t|
      t.string :day_of_the_week, :null => false
      t.time :first_game_time, :default => Time.local(2012, 1, 1, 8, 0)
      t.time :last_game_time, :default => Time.local(2012, 1, 1, 18, 0)
      t.integer :duration, :default => 75
    end
  end

  def down
    drop_table :game_slot_patterns
  end
end
