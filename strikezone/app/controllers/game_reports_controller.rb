class GameReportsController < ApplicationController
  def index
  end

  def new
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    @game_report = GameReport.new
  end

  def create
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])

    @game_report = GameReport.new
    
    @game_report.game = @game
    @game_report.user = current_user

    @game_report.home_team_score = params["home_team_score"].to_i
    @game_report.away_team_score = params["away_team_score"].to_i

    if @game.home_team === @team
      @game_report.home_or_away = "Home"
    else
      @game_report.home_or_away = "Away"
    end

    @game_report.comments = params["comments"]
    @game_report.save!

    redirect_to member_team_path(current_user, @team)

  end

end