class Admin::LocationsController < Admin::ApplicationController
  before_filter :set_section
  
  def index
    @locations = @hub.locations
  end
  
  def create
    @location = Location.create_from_dialog(@hub, params[:location])
    redirect_to admin_locations_path
  end
  
  protected 
  def set_section
    set_site_section("Locations")
  end
end