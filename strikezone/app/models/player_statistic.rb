class PlayerStatistic < ActiveRecord::Base
  attr_accessible :game_id, :player_id, :innings_pitched, :pitch_count, :innings_caught, :all_star_vote

  belongs_to :game
  belongs_to :player
end