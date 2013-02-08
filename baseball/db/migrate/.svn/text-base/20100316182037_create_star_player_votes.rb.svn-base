class CreateStarPlayerVotes < ActiveRecord::Migration
  def self.up
    create_table :star_player_votes do |t|
      t.column :participant_id, :integer, :null => false
      t.column :game_report_id, :integer, :null => false
      t.column :vote_rank, :integer
    end
  end

  def self.down
    drop_table :star_player_votes
  end
end
