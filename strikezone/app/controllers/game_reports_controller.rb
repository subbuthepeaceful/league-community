class GameReportsController < ApplicationController
  def index
  end

  def new
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    @game_report = GameReport.new
  end

  def show
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    @game_report = GameReport.find(params[:id])
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

    @team.players.each_with_index do |p, i|
      ps = PlayerStatistic.create(
        game_report: @game_report,
        player: p,
        innings_pitched: params["inn_p_player_#{i}"].to_f,
        pitch_count: params["pitch_ct_player_#{i}"].to_i,
        innings_caught: params["inn_c_player_#{i}"].to_f
      )
    end

    # TODO PLAYER ALL STAR VOTES
    for i in 1..3
      unless params["all_star_vote_#{i}"].blank?
        p = Player.find(params["all_star_vote_#{i}"].to_i)
        ps = PlayerStatistic.create(
          game_report: @game_report,
          player: p,
          all_star_vote: true
        )
      end
    end

    redirect_to member_team_path(current_user, @team)

  end

  def redo
    @team = Team.find(params[:team_id])
    @game = Game.find(params[:game_id])
    @game_report = GameReport.find(params[:id])

    @game_report.delete

    redirect_to new_team_game_game_report_path(@team, @game)

  end

end