class Admin::ApplicationController < ApplicationController
  layout "admin"
  before_filter :admin_login_required
  
  def admin_login_required
    unless current_user && current_user.is_admin?
      redirect_to new_login_path
    end
  end
  
  def set_site_section(section)
    @section = section
  end
end