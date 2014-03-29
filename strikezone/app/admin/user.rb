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
#      f.input :password
#      f.input :password_confirmation
      f.input :superadmin, :label => "Super Administrator"
    end
    f.buttons
  end

  filter :first_name
  filter :last_name
  filter :email

  new_user = Proc.new {
    @user = User.new
    render active_admin_template('new.html.erb')
  }

  member_action :new, :method => :get, &new_user

  create = Proc.new {
    @user = User.create(params[:user])
    @user.password = 'redStar'
    @user.save
    redirect_to admin_users_path
  }

  member_action :create, :method => :post, &create

  show = Proc.new {
    @user = User.find(params[:id])
    render active_admin_template('show.html.erb')
  }

  member_action :show, :method => :get, &show

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


#  create_or_edit = Proc.new {
#    @user            = User.find_or_create_by_id(params[:id])
#    @user.superadmin = params[:user][:superadmin]
#    @user.attributes = params[:user].delete_if do |k, v|
#      (k == "superadmin") ||
#      (["password", "password_confirmation"].include?(k) && v.empty? && !@user.new_record?)
#    end
#    if @user.save
#      redirect_to :action => :show, :id => @user.id
#    else
#      render active_admin_template((@user.new_record? ? 'new' : 'edit') + '.html.erb')
#    end
#  }
#  member_action :create, :method => :post, &create_or_edit
#  member_action :update, :method => :put, &create_or_edit  
end