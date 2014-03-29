class GamesController < ApplicationController

  def create
    @team = Team.find(params[:team_id])

    @game = Game.new
    @game.team = @team

    d = params[:new_game_date].match(/(\d\d)\/(\d\d)\/(\d\d\d\d)/)
    @game.game_date = "#{d[3]}-#{d[1]}-#{d[2]}".to_date

    @game.opponent = params[:new_game_opponent]
    @game.is_home_game = params[:new_game_home].nil? ? false : true
    @game.comments = params[:new_game_comments]
    @game.save!

    render :text => "OK"

  end

  def switch_home_away
    @game = Game.find(params[:id])

    @game.is_home_game = @game.is_home_game ? false : true
    @game.game_time = nil
    @game.game_slot = nil
    @game.save!

    render :text => "OK"
  end

  def update_away_details
    @game = Game.find(params[:id])

    # Presumably we are only updating the game's date/time, location
    p = params[:away_game_date_time].match(/(\d\d)\/(\d\d)\/(\d\d\d\d) (\d\d):(\d\d)/)
    new_game_date = "#{p[3]}-#{p[1]}-#{p[2]}".to_date

    new_game_time = DateTime.civil_from_format(:local, p[3].to_i, p[1].to_i, p[2].to_i, p[4].to_i, p[5].to_i)

    # Account for daylight savings

    @game.game_date = new_game_date
    @game.game_time = new_game_time

    @game.location = params[:away_game_location_field] + "," + params[:away_game_location_address_field]

    @game.save!

    @game.reload

    if Rails.env != "production"
      if @game.game_time.utc_offset == -25200
        @game.game_time = @game.game_time.advance(:hours => -1)
        @game.save!
      end
    end

    if Rails.env == "production"
      @game.game_time = @game.game_time.advance(:seconds => @game.game_time.utc_offset.abs)
      @game.save
    end


    render :text => "OK"
  end
end