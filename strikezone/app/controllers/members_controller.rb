class MembersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    # if @user.teams
    #   redirect_to member_team_path(@user, @user.teams[0])
    # end
  end

  def schedule_for_date
    @games = []
    p = params[:game_date].match(/(\d\d)\/(\d\d)\/(\d\d\d\d)/)
    @game_date = "#{p[3]}-#{p[1]}-#{p[2]}"
    @user = User.find(params[:id])
    @user.teams.each do |team|
      games_for_date = team.games.where(:game_date => @game_date)
      @games << games_for_date
    end
    @games.flatten!

    render :template => "members/schedule_for_date", :layout => false 
  end

end