class MessagesController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
    @participant = Participant.find(params[:participant_id])
    @default_participant = @participant
    @contact = current_user.contact
    
    @team = @participant.team
    @messages = @contact.mailbox.full_inbox
    
  end
  
  def create
    circles_message = CirclesMessage.create_from_params(params[:circles_message], @contact)
    if circles_message
      @participant = Participant.find(params[:participant_id])
      @team = @participant.team
      @team.send_circles_message(circles_message)
      redirect_to dashboard_participant_path(@participant)
    end
  end
  
  def read
    circles_message = CirclesMessage.find(params[:id])
    circles_message.mark_as_read(@contact)
    
    respond_to do |format|
      format.html
      format.js { render :text => "OK" }
    end
  end
  
  def reply
    circles_message = CirclesMessage.find(params[:id])
    circles_reply = circles_message.add_reply(params[:message_reply], @contact)
    if circles_reply
      if params[:sender] == "Sender Only"
        circles_message.contact.send_circles_message(circles_reply)
      else
        @participant = Participant.find(params[:participant_id])
        @team = @participant.team
        @team.send_circles_message(circles_reply)
      end
    end
    redirect_to dashboard_participant_path(@participant)
  end
  
end