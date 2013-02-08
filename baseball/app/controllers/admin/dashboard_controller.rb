class Admin::DashboardController < Admin::ApplicationController
  before_filter :set_section
  
  def index
  end
  
  protected
  
  def set_section
    set_site_section("Home")
  end
end