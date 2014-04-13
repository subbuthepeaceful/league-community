class GameReport < ActiveRecord::Base
  attr_accessible :game_id, :user_id, :home_team_score, :away_team_score, :comments, :home_or_away 

  belongs_to :game
  belongs_to :user

  has_many :player_statistics

  def final_score
    "#{away_team_score.to_i} - #{home_team_score.to_i}"
  end
end