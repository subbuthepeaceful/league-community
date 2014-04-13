class PlayerStatistic < ActiveRecord::Base
  attr_accessible :game_report_id, :game_report, :player, :player_id, :innings_pitched, :pitch_count, :innings_caught, :all_star_vote

  belongs_to :game_report
  belongs_to :player
end