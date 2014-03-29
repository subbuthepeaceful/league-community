class GameSlotPattern < ActiveRecord::Base
  attr_accessible :day_of_the_week, :first_game_time, :last_game_time, :duration

  def first_game_time_display
    first_game_time.localtime.strftime("%I:%M %p")
  end
  def last_game_time_display
    last_game_time.localtime.strftime("%I:%M %p")
  end
end