# ActiveAdmin.register AgeGroup do
#   index do
#     column :name
#     column :team_size
#     column :available_fields
#     column :game_slot_duration
#     default_actions
#   end
#   form do |f|
#     f.inputs "Age Group Details" do
#       f.input :name
#       f.input :team_size
#       f.input :fields, :as => :check_boxes
#       f.input :game_slot_duration, :as => :select, :collection => [75,90, 120]
#     end
#     f.buttons
#   end
# end