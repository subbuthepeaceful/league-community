class ParticipantsController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
  end
  
  def show
    render :action => "dashboard"
  end
  
  def dashboard
    @participant = Participant.find(params[:id])
    @default_participant = @participant
    
    # TO DO : Do we need to check whether the participant ID belongs to this contact
    
    @team = @default_participant.team
    determine_head_coach
    
    if current_user.is_admin?
      @messages = @default_participant.primary_contact.mailbox.inbox
    else
      @messages = @contact.mailbox.inbox
    end
    @team_photos = Photo.team_photos(@default_participant.team, 5)
    
    # Participant may belong to multiple teams
    @teams = @default_participant.teams
  end
  
  def update_availability
    @participant = Participant.find(params[:id])
    @team = @participant.team
    games = @team.games
    games.each{|game|
      availability = Availability.find_by_participant_id_and_game_id(@participant.id,game.id)
      if !availability
        availability = Availability.new
        availability.game_id=game.id
        availability.participant=@participant
      end
      availability.available=params[:games] && params[:games].has_key?("#{game.id}")
      availability.save!
    }
    redirect_to availability_participant_path(@participant)
  end
  
  def schedule
    @nav="schedule"
    @participant = Participant.find(params[:id])
    @team = @participant.team
    determine_head_coach

    @calendar = @participant.division.calendar(@team)
    respond_to do |format|
      format.html 
      format.json { render :json => @calendar.to_json(:methods => [:start, :title, :className, :eventType])}
    end
  end
  
  def snack_signup
    @participant = Participant.find(params[:id])
    @team = @participant.team
    game=Game.find(params[:game_id])
    if game
      game.set_snack_volunteer(@team, @participant)
      #game.save!
      render :text => @participant.primary_contact.name
    else
      render :text => ""
    end
  end
  
  def clear_snack_signup
    @participant = Participant.find(params[:id])
    @team = @participant.team
    game=Game.find(params[:game_id])
    if game
      game.set_snack_volunteer(@team, nil)
      #game.save!
      render :text => ""
    end
  end
  
  def gamelist
    @nav="schedule"
    @participant = Participant.find(params[:id])
    @team = @participant.team
    determine_head_coach

    @calendar = @participant.division.calendar(@team,true,false)
  end
  
  def roster
    @nav="roster"
    @participant = Participant.find(params[:id])
    @team = @participant.team
    determine_head_coach
  end
  
  def availability
    @nav="roster"
    @participant = Participant.find(params[:id])
    @team = @participant.team
    determine_head_coach
  end

  def resources
    @nav = "resources"
  end

  def sponsors
    @nav = "sponsors"
    @sponsors = Sponsor.find(:all)
  end
  
  def update_teamname
    @participant = Participant.find(params[:id])
    @team = Team.find(params[:team][:id])
    @team.set_selected_name(params[:team][:selected_name])
    redirect_to dashboard_participant_path(@participant)
  end
  
  def update_profile_photo
    @participant = Participant.find(params[:id])
    @participant.update_profile_photo(params[:participant][:profile_photo])    
    redirect_to dashboard_participant_path(@participant)
  end  
  
  def update_contact_profile_photo
    @participant = Participant.find(params[:id])
    @contact.update_profile_photo(params[:contact][:profile_photo])    
    redirect_to dashboard_participant_path(@participant)
  end  

  def update_team_logo
    @participant = Participant.find(params[:id])
    @team = @participant.team
    @team.update_team_logo(params[:team][:logo])    
    redirect_to dashboard_participant_path(@participant)
  end  
  
  protected
  def determine_head_coach
    # Determine if current contact i.e. logged in User is Head Coach
    @head_coach = @team.head_coach
    if @head_coach == @contact
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