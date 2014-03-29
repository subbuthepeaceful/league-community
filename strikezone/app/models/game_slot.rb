class GameSlot < ActiveRecord::Base
  attr_accessible :field, :game_date_time, :game_id

  belongs_to :field
  has_one :game

  def self.create_from_pattern_for_season(game_slot_pattern, season, field)
    # Lets assume that Game Days for Club Soccer are Saturday and Sunday
    game_day_offset = game_slot_pattern.day_of_the_week == "Saturday" ? -1 : 0
    game_day = season.start_date.end_of_week.advance(:days => game_day_offset)
    CUSTOM_LOGGER.info "Found Season Start as #{season.start_date}"
    while game_day < season.end_date
      CUSTOM_LOGGER.info "Game Day #{game_day}"
      last_game_time = DateTime.civil_from_format(:local, game_day.year, game_day.month, game_day.day, game_slot_pattern.last_game_time.localtime.hour-1, game_slot_pattern.last_game_time.localtime.min)

      game_time = DateTime.civil_from_format(:local, game_day.year, game_day.month, game_day.day, game_slot_pattern.first_game_time.localtime.hour-1, game_slot_pattern.first_game_time.localtime.min)
      while game_time <= last_game_time

        game_slot = GameSlot.create(field: field, game_date_time: game_time)
        game_slot.save!

        CUSTOM_LOGGER.info "Game Slot #{game_time}"

        game_time = game_time.advance(:minutes => game_slot_pattern.duration)
      end
      game_day = game_day.advance(:days => 7)
    end
  end

  def game_date_time_time_display
    game_date_time.strftime("%I:%M %p")
  end

  def game_date_time_date_display
    game_date_time.strftime("%a %b-%d")
  end

  def game_date_time_display
    game_date_time
  end

  def available?
    game ? false : true
  end

end