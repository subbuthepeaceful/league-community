class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  attr_accessible :user_id, :user, :team, :team_id, :name
end