class CreateGameSlots < ActiveRecord::Migration
  def up
    create_table :game_slots do |t|
      t.integer :field_id, :null => false
      t.datetime :game_date_time
    end
  end

  def down
    drop_table :game_slots
  end
end
