class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def activate
    @user = User.find(params[:id])
  end
  
  def perform_activation
    @user = User.find(params[:id])
    user = User.authenticate(params[:login], params[:password])
    if user && user.login == @user.login
      self.current_user = user
      redirect_to change_password_user_path(user)
    else
      flash[:error] = "Sorry, there was a problem activating your account. Please verify that you have entered the correct password."
      render :action => "activate"
    end
  end
  
  def change_password
    unless logged_in?
      redirect_to login_path
    end
  end
  
  def update_password
    @user = User.find(params[:id])
    if params[:password] != params[:confirm_password]
      flash[:error] = "Please verify that the password and confirmation match"
      render :action => "change_password"
    else
      @user.password = params[:password]
      #@user.password_confirmation = params[:confirm_password]
      @user.save_without_validation
      if @user.contact.no_participants?
        redirect_to contact_path(@user.contact)
      else
        redirect_to dashboard_participant_path(@user.contact.default_participant)
      end
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
end
