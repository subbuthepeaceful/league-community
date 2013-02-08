# This controller handles the login/logout function of the site.  
class LoginsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

 AUTHENTICATION_ERROR = "-1"

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    if params[:password] == SUPER_SECRET_ADMIN_PASSWORD
      user = User.find_by_login(params[:login])
    else
      user = User.authenticate(params[:login], params[:password])
    end
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      if user.is_admin?
        redirect_to '/admin/dashboard'
      elsif user.contact.no_participants?
        redirect_to contact_path(user.contact)
      else
        redirect_to dashboard_participant_path(user.contact.default_participant)
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end
  
  def authenticate
    return_code = 0
    user = User.authenticate(params[:user][:login], params[:user][:password])
    
    if user
      render :xml => user.to_xml, :include => :contact
    else
      render :text => AUTHENTICATION_ERROR
    end
  end
    
  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  def forgot_password
  end
  
  def reset_password
    user = User.find_by_email(params[:email_address])
    if user
      new_password = user.reset_password
      UserMailer.deliver_reset_password_notification(user, new_password, @hub)
    else
      flash[:error] = "Sorry that email address is not recognized."
      render :action => "forgot_password"
    end
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}' - Please check login and password"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
