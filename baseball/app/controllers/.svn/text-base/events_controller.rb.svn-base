class EventsController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
  end
  
  def show
    @participant = Participant.find(params[:participant_id])
    @eventType = params[:event_type]
    eventHash = Hash.new
    case @eventType
    when "Game"
      @game = Game.find(params[:id])
    when "Event"
      @event = Event.find(params[:id])
    end
    render :layout => false
  end
  
  
end