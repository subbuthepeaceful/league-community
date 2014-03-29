class TeamsController < ApplicationController
  before_filter :check_logged_in
  def index
  end

  def show
    @user = User.find(params[:member_id])
    @team = Team.find(params[:id])

    @fields = @team.age_group.fields
  end
end