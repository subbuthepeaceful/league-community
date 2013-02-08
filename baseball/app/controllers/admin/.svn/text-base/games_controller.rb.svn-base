class Admin::GamesController < Admin::ApplicationController
  before_filter :set_section
  
  def index
  end
  
  def show
  end
  
  def update
    @division = Division.find(params[:division_id])
    @game = Game.find(params[:id])
    @game.update_from_params(params)
    
    @program = @division.program
    @session = @program.currently_active_session
    redirect_to define_dates_admin_program_session_division_path(@program, @session, @division)
  end
  
  protected 
  def set_section
    set_site_section("Programs")
  end
end  