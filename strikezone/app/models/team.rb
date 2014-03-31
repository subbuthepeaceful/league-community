class Team < ActiveRecord::Base
  attr_accessible :name, :gender, :age_group_id, :external_url, :division_id, :authorized_user_ids

  belongs_to :division
  has_and_belongs_to_many :authorized_users

  has_many :roles
  has_many :users, :through => :roles

  has_many :home_games, :foreign_key => :home_team_id
  has_many :away_games, :foreign_key => :away_team_id

  has_many :players

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

  def authorized_user_list
    authorized_users.collect { |a| a.name }.join(",")
  end

  def add_as_coach(user)
  end
end