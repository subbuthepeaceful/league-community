class Admin::SponsorsController < Admin::ApplicationController
  before_filter :set_section

  def index
    @sponsors = Sponsor.find(:all)
    if params[:view].blank?
      @view = "list"
    else
      @view = params[:view]
    end
    
  end

  def show
    @sponsor = Sponsor.find(params[:id])
  end

  def create
    @sponsor = Sponsor.create(params[:sponsor])
    redirect_to admin_sponsors_path
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy if @sponsor
    redirect_to admin_sponsors_path
  end

  
  protected
  def set_section
    set_site_section("Advertising")
  end
end