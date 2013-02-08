class AdminRolesController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
    if params[:division_id]
      @division = Division.find(params[:division_id])
      redirect_to gamelist_division_path(@division)
    elsif params[:hub_id]
      # This is for a league executive
      @divisions = @hub.programs[0].divisions
      redirect_to view_hub_path(@hub)
    end
  end
end