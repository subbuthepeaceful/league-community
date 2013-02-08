class Admin::SessionsController < Admin::ApplicationController
  before_filter :set_section
  
  def index
    @program = Program.find(params[:program_id])
    @sessions = @program.sessions
    if params[:view].blank?
      @view = "list"
    else
      @view = params[:view]
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @sessions.to_xml }
    end
  end
  
  def create
    @program = Program.find(params[:program_id])
    @session = Session.create_session_for_program(@program, params[:session])
    redirect_to admin_program_sessions_path(@program)
  end
  
  def show
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:id])
    redirect_to admin_program_session_divisions_path(@program, @session)
  end
  
  def schedule
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:id])
    
    @events = @session.events
    
    respond_to do |format|
      format.html
      format.json { render :json => @events.to_json(:methods => [:start, :end, :title, :className])}
    end
  end
  
  def add_event
    @program = Program.find(params[:program_id])
    @session = Session.find(params[:id])
    Event.create_from_dialog(@session, params[:event])
    redirect_to schedule_admin_program_session_path(@program, @session)
  end
    
  def schedules
    @program = Program.find(params[:program_id])
    @sessions = @program.sessions
    
    respond_to do |format|
      format.html 
      format.json { render :json => @sessions.to_json(:methods => [:start, :end, :title, :className]) }
    end
  end  
    
  protected 
  def set_section
    set_site_section("Programs")
  end
end  