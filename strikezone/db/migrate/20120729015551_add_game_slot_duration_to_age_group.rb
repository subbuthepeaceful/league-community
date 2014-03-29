class AddGameSlotDurationToAgeGroup < ActiveRecord::Migration
  def up
    add_column :age_groups, :game_slot_duration, :integer, :default => 75
  end

  def down
    remove_column :age_groups, :game_slot_duration
  end
end
