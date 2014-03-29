class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_club, :set_user
  
  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.superadmin?
      flash[:alert] = "Unauthorized access"
      redirect_to root_path
    end
  end

  def set_club
    @club = Club.first
  end

  def set_user
    @user = current_user
  end

  def after_sign_in_path_for(user)
    member_path(user)
  end

  def check_logged_in
    unless current_user
      redirect_to root_path
    end
  end

end
