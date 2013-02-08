class Admin::DivisionsController < Admin::ApplicationController
  before_filter :set_section
  
  def index
    @program = Program.find(params[:program_id])
    if params[:session_id]
      @session = Session.find(params[:session_id])
    else
      @session = @program.currently_active_session
    end
    @divisions = @program.divisions
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @divisions.to_xml }
    end
  end
  
  def create
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:session_id])
    @division = Division.create_division_for_program(@program, @session, params[:division])
    redirect_to admin_program_session_divisions_path(@program)
  end
  
  def show
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:session_id])
    @division = Division.find(params[:id])
    redirect_to admin_program_session_division_teams_path(@program, @session, @division)
  end
  
  def define_dates
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:session_id])
    @division = Division.find(params[:id])
    
    @teams = @division.teams
    @locations = @hub.locations
  end
  
  def update_schedule
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:session_id])
    @division = Division.find(params[:id])
    @division.create_weekly_schedule_from_params(params)
    redirect_to define_dates_admin_program_session_division_path(@program, @session, @division)
  end
  
  def schedule
    @division = Division.find(params[:id])
    @calendar = @division.calendar
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @games.to_xml }
      format.json { render :json => @calendar.to_json(:methods => [:start, :title, :className])}
    end
  end
  
  def activate
    @division = Division.find(params[:id])
    @division.activate_online_access(params[:welcome_email_subject], params[:welcome_email_message])
    redirect_to '/admin/dashboard'
  end
  
  def add_event
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:session_id])
    @division = Division.find(params[:id])
    Event.create_division_event_from_dialog(@division, params[:event])
    redirect_to admin_program_session_division_teams_path(@program, @session, @division)
  end
  
  
  protected 
  def set_section
    set_site_section("Programs")
  end
end
