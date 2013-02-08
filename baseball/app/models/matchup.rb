class Matchup < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  
  # Class Methods
  def self.create_new_matchups(game, home_team, away_team)
    h = Matchup.new
    h.game = game
    h.team = home_team
    h.home_or_away = "Home"
    h.save
    
    a = Matchup.new
    a.game = game
    a.team = away_team
    a.home_or_away = "Away"
    a.save
  end
    
end