class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :jersey_number, :team_id

  belongs_to :team
end