# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Include Restful Authentication Plugin
  include AuthenticatedSystem
  
  # Include Helpful Utilities
  include CirclesUtilities

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  # Always set the hub as a global before filter
  before_filter :set_hub
  
  
  # Set Hub based on subdomain in request
  def set_hub
    # First check fully qualified url
    @hub = Hub.find_by_full_circles_domain(request.server_name)
    if @hub.nil?
      @hub = Hub.find_by_url_prefix(current_subdomain)
      @operating_domain = "#{current_subdomain}.strongcircles.com"
    else
      @operating_domain = "#{request.server_name}"
      @suppress_header = true
    end
    Time.zone = @hub.time_zone
    
    load_hub_circle_options
    
    @sponsor = random_sponsor 
  end
  
  # Set Login Required
  def login_required
    unless logged_in?
      redirect_to '/'
    end
  end
  
  # Set Contact
  def set_contact
      @contact = current_user.contact
      if current_user.is_admin?
        @participants = Participant.find(:all)
      else
        if @contact.has_participants?
          @participants = @contact.participants
          @participant = @contact.default_participant
        end
        if @contact.has_admin_role?
          @enable_tabs = @contact.admin_visibility
        end
      end
  end

  # Set Participant
  def set_participant
    @participant = Participant.find(params[:participant_id])
  end
  
  def random_sponsor
    @sponsors = @hub.sponsors
    i = rand(@sponsors.size)
    return @sponsors[i]
  end

  protected
  def load_hub_circle_options
    @messages_enabled = @hub.messages_enabled?
    @pictures_enabled = @hub.pictures_enabled?
    @resources_enabled = @hub.resources_enabled?
    @sponsors_enabled = @hub.sponsors_enabled?
  end

end
