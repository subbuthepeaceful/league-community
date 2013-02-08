class Admin::TeamsController < Admin::ApplicationController
  before_filter :set_section
  
  def index
    if params[:program_id]
      @program = Program.find(params[:program_id])
    end
    if params[:division_id]
      @division = Division.find(params[:division_id])
    end
    if params[:session_id]
      @session = Session.find(params[:session_id])
    else
      @session = @program.currently_active_session
    end
    
    @teams = @division.teams_for_session(@session)
    
    @registrants = @division.registrations.collect { |r| r.primary_contact }
    if @registrants.size == 0
      @registrants = Registration.find(:all).collect { |r| r.primary_contact }
    end
    
  end
  
  def create
    @program = Program.find(params[:program_id])
    @division = Division.find(params[:division_id])
    @team = Team.create_team_for_program_division(@program, @division, params[:team])
    redirect_to admin_program_session_division_teams_path(@program, @program.currently_active_session, @division)
  end
  
  def show
    @team = Team.find(params[:id])
    @program = @team.session.program
    @session = @team.session
    @division = @team.division
  end
  
  def edit
    @team = Team.find(params[:id])
    @program = @team.session.program
    @session = @team.session
    @division = @team.division
    
    @registrants = @division.registrations
    @registrants.reject! { |r| r.session != @session }
    if @registrants.size == 0
      @registrants = Registration.find(:all)
    end
  end  
  
  def update
    @team = Team.find(params[:id])
    @team_participants = params[:team_roster_list]

    @team.update_roster(@team_participants)
    
    @program = @team.session.program
    @session = @team.session
    @division = @team.division
    
    redirect_to admin_program_session_division_teams_path(@program, @session, @division)

  end
  
  def assign_coaches
    @team = Team.find(params[:team_id])
    
    unless params[:head_coach].empty?
      @team.assign_coach_from_params(params[:head_coach], "Head Coach") 
    end
    unless params[:assistant_coach_1].empty?
      @team.assign_coach_from_params(params[:assistant_coach_1], "Assistant Coach")
    end
    unless params[:assistant_coach_2].empty?
      @team.assign_coach_from_params(params[:assistant_coach_2], "Assistant Coach")
    end
    
    @program = @team.session.program
    @session = @team.session
    @division = @team.division
    
    redirect_to admin_program_session_division_teams_path(@program, @session, @division)
    
  end
  
  protected 
  def set_section
    set_site_section("Programs")
  end
end