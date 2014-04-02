ActiveAdmin.register Team do
  filter :division

  index do 
    column :division
    column :name
    column :authorized_user_list
    default_actions
  end

  form do |f|
    f.inputs "Details" do 
      f.input :division
      f.input :name
      f.input :authorized_users, :as => :select, :collection => AuthorizedUser.all
    end
    f.buttons
  end

end