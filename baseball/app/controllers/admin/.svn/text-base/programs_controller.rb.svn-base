class Admin::ProgramsController < Admin::ApplicationController
  before_filter :set_section
  
  def index
    @program_groups = Program.program_groups_for_select(@hub)
    @programs = @hub.programs
    if params[:view].blank?
      @view = "list"
    else
      @view = params[:view]
    end
  end
  
  def show
    @program = Program.find(params[:id])
    redirect_to admin_program_sessions_path(@program)
  end
  
  def create
    @program = Program.create_from_dialog(current_user, @hub, params[:program])
    redirect_to admin_programs_path
  end
  
  ######
  def schedules
    @programs = @hub.programs
    @sessions = Array.new
    @programs.map { |p| @sessions << p.currently_active_session }
    
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