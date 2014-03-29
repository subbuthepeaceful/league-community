ActiveAdmin.register GameSlot do
  index do
    column "Field", :field
    column "Game Date", :game_date_time_display, :sortable => :game_date_time
    default_actions
  end
end