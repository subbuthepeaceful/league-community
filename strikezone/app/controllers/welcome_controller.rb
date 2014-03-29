class WelcomeController < ApplicationController
  before_filter :redirect_for_logged_in
  def index
    @user = User.new
  end

  private
  def redirect_for_logged_in
    if current_user
      redirect_to member_path(current_user)
    end
  end
end