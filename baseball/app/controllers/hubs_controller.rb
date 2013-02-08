class HubsController < ApplicationController
  before_filter :login_required, :set_contact
  
  def view
    setup_divisions
    #@games = @division.scheduled_games
    @games = @division.all_games
    
    
    @nav = "admin"
  end
  
  def votes
    setup_divisions
    @top_voted_players = @division.top_voted_players

    @nav = "admin"
  end
  
  protected
  def setup_divisions
    @divisions = []
    @hub.programs[0].divisions.each do |division|
      if division.has_schedule? 
        @divisions << division
      end
    end
    if params[:division_id]
      @division = Division.find(params[:division_id])
    else
      @division = @divisions[0]
    end
    
    @selected_division = @division
    @selected_division_index = @divisions.index(@selected_division)
  end
end