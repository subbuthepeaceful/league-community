class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :participant
end