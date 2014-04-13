class GameReport < ActiveRecord::Base
  attr_accessible :game_id, :user_id, :home_team_score, :away_team_score, :comments, :home_or_away 

  belongs_to :game
  belongs_to :user

  has_many :player_statistics

  def final_score
    "#{away_team_score.to_i} - #{home_team_score.to_i}"
  end

  def star_players
    players = []
    player_statistics.map { |ps|
      if ps.all_star_vote
        players << ps.player.full
      end
    }
    players.join(",")
  end

  def team_player_statistics(team)
    player_statistics.select { |ps| ps.player.team === team}
  end
end