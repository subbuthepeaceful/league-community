class Game < ActiveRecord::Base
  attr_accessible :team_id, :external_id, :game_date, :game_time, :opponent, :is_home_game, :location, :status, :field_duties, :game_slot_id, :comments, :division, :league

  belongs_to :team
  belongs_to :game_slot

  def field
    if game_slot
      game_slot.field.name
    else
      location
    end
  end

  def scheduled?
    game_time? ? true : false
  end

  def home_or_away
    is_home_game ? "Home" : "Away"
  end

end