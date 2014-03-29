class AgeGroup < ActiveRecord::Base
  attr_accessible :name, :team_size, :field_ids, :game_slot_duration

  has_and_belongs_to_many :fields
  has_many :teams

  def younger(num=1)
    age = name[1..name.length].to_i
    AgeGroup.find_by_name("U#{age-1}")
  end
end