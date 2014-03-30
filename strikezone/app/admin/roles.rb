ActiveAdmin.register Role do
  index do
    column :user
    column :team
    column :name
    default_actions
  end
  form do |f|
    f.inputs "Details" do 
      f.input :user
      f.input :team
      f.input :name, :as => :select, :collection => ["Coaching Staff"]
    end
    f.buttons
  end
end