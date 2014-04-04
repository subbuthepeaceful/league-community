class TeamsController < ApplicationController
  before_filter :check_logged_in
  def index
  end

  def show
    @user = User.find(params[:member_id])
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @user = User.find(params[:member_id])
    @team = Team.find(params[:id])

    @team.players.delete_all
    for i in 0..15
      unless params["player_fname_#{i}"].blank?
        player = Player.create(first_name: params["player_fname_#{i}"], 
                               last_name: params["player_lname_#{i}"],
                               jersey_number: params["player_jersey_num_#{i}"],
                               team_id: @team.id)
      end
    end

    redirect_to member_team_path(@user, @team)
  end
end