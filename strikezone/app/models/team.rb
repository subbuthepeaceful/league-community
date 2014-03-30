class Team < ActiveRecord::Base
  attr_accessible :name, :gender, :age_group_id, :external_url

  # belongs_to :age_group
  belongs_to :division
  has_many :roles
  has_many :users, :through => :roles

  has_many :games, :order => "game_date"

  def coach
    r = roles.find_by_name("Coach")
    r ? r.user.name : "TBD" 
  end

  def coach_as_member
    r = roles.find_by_name("Coach")
    r ? r.user : nil
  end

  def manager
    r = roles.find_by_name("Manager")
    r ? r.user : nil
  end

  def related_teams
    team_list = []
    
    team_list << age_group.teams.where(:gender => self.gender)
    team_list.delete(self)

    team_list << age_group.younger(1).teams.where(:gender => self.gender)
    team_list.flatten!

    team_list
  end

  def administerable?(user)
    users.include?(user)
  end
end