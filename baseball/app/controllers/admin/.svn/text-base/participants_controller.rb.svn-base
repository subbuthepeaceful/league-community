class Admin::ParticipantsController < Admin::ApplicationController
  before_filter :set_section
  
  include CirclesImporter
  
  def index
    @participants = @hub.participants
    @participants.reject! { |p| !(p.has_registration_for_session(@hub.default_program.currently_active_session)) }
    @programs = @hub.programs
  end
  
  def create
    participant = Participant.create_from_dialog(current_user, @hub, params[:participant])
    redirect_to admin_participants_path
  end
  
  def import
    #puts "Importing Participants"
    csv_file = params[:import][:import_file]
    #@importable_participants = parse_participant_import(csv_file)
    
    # Identify Program/Session/Division
    @session = Session.find(params[:import][:session])
    @division = Division.find(params[:import][:division])
    @program = Program.find(params[:import][:program])
    
    parse_and_load_participant_import(csv_file, @program, @session, @division)
    redirect_to admin_participants_path
  end
  
  def confirm_import
    puts "Importing #{params[:firstname]} #{params[:lastname]}"
    @participant = Participant.create_from_confirm_import(current_user, @hub, params)
    render :text => "OK"
  end
  
  def resend_activation
    @participant = Participant.find(params[:id])
    @participant.resend_activation
    redirect_to admin_participants_path
  end
  
  def activate
    @participant = Participant.find(params[:id])
    @participant.activate
    redirect_to admin_participants_path
  end
  
  protected
  def set_section
    set_site_section("Users")
  end
  
    
end