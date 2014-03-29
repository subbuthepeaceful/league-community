ActiveAdmin.register Field do
  form do |f|
    f.inputs "Field Details" do
      f.input :name
      f.input :location
      f.input :address
      f.input :instructions
      f.input :age_groups, :as => :check_boxes
    end
    f.buttons
  end
end