class GameStatistic < ActiveRecord::Base
  belongs_to :game_report
  belongs_to :participant
end