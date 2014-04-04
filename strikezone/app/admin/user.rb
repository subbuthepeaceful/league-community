ActiveAdmin.register User do 
  index do
    column :first_name
    column :last_name
    column :email
    column :superadmin
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :superadmin, :label => "Super Administrator"
    end
    f.buttons
  end

  edit = Proc.new {
    @user = User.find(params[:id])
    render active_admin_template('edit.html.erb')
  }

  member_action :edit, :method => :get, &edit

  update = Proc.new {
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    if @user.save
      redirect_to :action => :show, :id => @user.id
    else
      render active_admin_template('edit.html.erb')
    end
  }

  member_action :update, :method => :put, &update

  destroy = Proc.new {
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  }

  member_action :destroy, :method => :delete, &destroy

end