class TeamsController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
  end
  
  def show
    @nav = "coaching"
    @team = Team.find(params[:id])
    determine_head_coach
    
    redirect_to gamelist_team_path(@team)
  end
  
  def schedule
    @nav = "coaching"
    @team = Team.find(params[:id])
    determine_head_coach
    
    @calendar = @team.division.calendar(@team)
    respond_to do |format|
      format.html 
      format.json { render :json => @calendar.to_json(:methods => [:start, :title, :className, :eventType])}
    end
  end
  
  def gamelist
    @nav = "coaching"
    @team = Team.find(params[:id])
    determine_head_coach
    
    @calendar = @team.division.calendar(@team,true,false)
  end
  
  def update_jersey_number
    @team = Team.find(params[:id])
    @team.update_jersey_numbers(params)

    @participant = Participant.find(params[:current_participant])
    redirect_to roster_participant_path(@participant)
  end
  
  def update_player_names_and_jerseys
    @team = Team.find(params[:id])
    @team.update_player_names_and_jerseys(params)
    
    @particpant = Participant.find(params[:current_participant])
    redirect_to roster_participant_path(@participant)
  end
  
  protected
  def determine_head_coach
    if @team.head_coach == @contact
      @is_head_coach = true
    else
      @is_head_coach = false
    end
    # Determine assistant coach
    if @team.assistant_coaches.include?(@contact)
      @is_assistant_coach = true
    else
      @is_assistant_coach = false
    end
    
  end
end