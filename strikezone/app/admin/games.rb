ActiveAdmin.register Game do
  index do 
    column "Game #", :external_id
    column "Team", :team
    column "Date", :game_date
    column "Time", :game_time
    column "Field", :field
    column "Opponent", :opponent
    column "Status", :status
    column "Home/Away", :home_or_away
    column "Comments", :comments
    default_actions
  end

  form do |f|
    f.inputs "Game Details" do
      f.input :external_id, :label => "Game #"
      f.input :team
      f.input :opponent
      f.input :is_home_game
      f.input :game_date
      f.input :game_time
      f.input :comments
    end
    f.buttons
  end

  filter :team
end