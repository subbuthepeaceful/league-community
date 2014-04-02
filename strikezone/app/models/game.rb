class Game < ActiveRecord::Base
  attr_accessible :home_team_id, :away_team_id, :game_date, :game_time, :location, :status, :field_duties, :comments, :division, :league

  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"

  def scheduled?
    game_time? ? true : false
  end

  def opponent(team)
    team == home_team ? "vs. #{away_team}" : " at #{home_team}"
  end

end