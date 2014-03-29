class Field < ActiveRecord::Base
  attr_accessible :name, :location, :address, :instructions

  has_and_belongs_to_many :age_groups
  has_many :game_slots 

  def game_slots_for_date(game_date)
    start_date = game_date.to_date.to_time_in_current_zone
    end_date = start_date.advance(:days => 1)
    game_slots.where(:game_date_time => start_date..end_date)
  end

  def calendar
  	@entries = {}

  	game_slots.each do |game_slot|
  		game_slot_date = game_slot.game_date_time_date_display
  		if !(@entries.has_key?(game_slot_date))
  			@entries[game_slot_date] = []
  		end
  		if game_slot.game
  			@entries[game_slot_date] << game_slot.game
  		end
  	end

  	@entries
  end

  def in_use?
    game_slots && game_slots.size > 0
  end

  def self.in_use
    all_fields = Field.all
    all_fields.delete_if { |f| !f.in_use? }
  end

end