class CreatePlayerStatistics < ActiveRecord::Migration
  def up
    create_table :player_statistics do |t|
      t.integer :game_report_id, :null => false
      t.integer :player_id, :null => false
      t.float :innings_pitched
      t.integer :pitch_count
      t.float :innings_caught
      t.boolean :all_star_vote
    end
  end

  def down
    drop_table :player_statistics
  end
end
