class Game < ActiveRecord::Base
  attr_accessible :home_team_id, :away_team_id, :game_date, :game_time, :location, :status, :field_duties, :comments, :division, :league

  belongs_to :home_team, :class_name => "Team"
  belongs_to :away_team, :class_name => "Team"

  has_many :game_reports

  def scheduled?
    game_time? ? true : false
  end

  def opponent(team)
    team == home_team ? away_team : home_team
  end

  def opponent_display(team)
    team == home_team ? "vs. #{away_team}" : " at #{home_team}"
  end

  def home_team_report
    game_reports.select { |g| g.home_or_away == "Home"}.first
  end

  def away_team_report
    game_reports.select { |g| g.home_or_away == "Away"}.first
  end

  def final_score
    if home_team_report
      home_team_report.final_score
    else
      "N/A"
    end
  end

end