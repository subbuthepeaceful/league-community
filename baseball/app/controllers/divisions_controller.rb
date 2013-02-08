class DivisionsController < ApplicationController
  before_filter :login_required, :set_contact, :except => [:show, :scores, :standings]
  def schedule
    @division = Division.find(params[:id])
    @games = @division.scheduled_games
    
    if @enable_tabs
      @nav = "admin"
    elsif @division.head_coaches.include?(@contact)
      @is_head_coach = true
      @nav = "division"
    end
    
    respond_to do |format|
      format.html 
      format.xml { 
        @games_in_xml = @games.to_xml :methods => [:title], :include => [:location, :teams ]
        render :xml => @games_in_xml 
      }
      format.json { render :json => @games.to_json(:methods => [:start, :title, :className])}
    end
  end
  
  def gamelist 
    @division = Division.find(params[:id])
    @games = @division.scheduled_games
    
    if @enable_tabs
      @nav = "admin"
    elsif @division.head_coaches.include?(@contact)
      @is_head_coach = true
      @nav = "division"
    end
  end  
  
  def view
    @division = Division.find(params[:id])
    @games = @division.scheduled_games
    @nav = "division"
    
    # We need to set the Head Coach flag if the logged in user.contact is a head coach in the division
    if @division.head_coaches.include?(@contact)
      @is_head_coach = true
    end
    
  end
  
  def votes
    @division = Division.find(params[:id])
    @top_voted_players = @division.top_voted_players
    @nav = "admin"
    # We need to set the Head Coach flag if the logged in user.contact is a head coach in the division
    if @division.head_coaches.include?(@contact)
      @is_head_coach = true
    end
  end
    
  def show
    @division = Division.find(params[:id])
    @program = @division.program
  end
  
  # Standings
  def scores
    @division = Division.find(params[:id])
    @games = @division.scheduled_games
    
    render :template => "divisions/scores", :layout => "iframe"
  end
  
  def standings
    @division = Division.find(params[:id])
    @teams = @division.teams_for_session(@division.program.currently_active_session)
    
    @games = @division.scheduled_games
    
    @teams.sort! { |a,b| (b.team_record ? (b.team_record.win_pct) : 0) <=> (a.team_record ? (a.team_record.win_pct) : 0) }
    render :template => "divisions/standings", :layout => "iframe"
  end
end
