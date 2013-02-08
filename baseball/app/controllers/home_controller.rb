class HomeController < ApplicationController
  def index
    if logged_in?
      participant = current_user.contact.default_participant
      redirect_to dashboard_participant_path(participant)
    end
    @programs = @hub.programs
  end
end