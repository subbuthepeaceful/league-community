class Users::RegistrationsController < Devise::RegistrationsController
  def create
    # Check if user has been added as an authorized user
    authorized_user = AuthorizedUser.find_by_email(params[:user][:email])
    if authorized_user
      user = User.create(
        first_name: authorized_user.first_name,
        last_name: authorized_user.last_name,
        email: params[:user][:email],
        password: params[:user][:password],
        password_confirmation: params[:user][:password_confirmation]
        )
      sign_in user
      flash[:notice] = "Welcome to Strikezone"
      redirect_to member_path(user)
    else
      flash[:error] = "Sorry you are not authorized for this application"
    end
  end
end