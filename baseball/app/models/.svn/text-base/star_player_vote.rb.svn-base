class StarPlayerVote < ActiveRecord::Base
  belongs_to :participant
  belongs_to :game_report
  
  def is_preseason_vote?
    self.game_report.game.is_preseason?
  end
end
