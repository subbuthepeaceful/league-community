class DashboardController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
    @participants = @contact.participants
    @default_participant = @participants[0]
    # Assume that even if there are multiple participants there is a single team for the moment
    
    @team = @default_participant.team
    @messages = @contact.mailbox.inbox
  end
end