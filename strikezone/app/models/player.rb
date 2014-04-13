class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :jersey_number, :team_id

  belongs_to :team

  def full
    "\#(#{jersey_number}) #{first_name} #{last_name}"
  end
end