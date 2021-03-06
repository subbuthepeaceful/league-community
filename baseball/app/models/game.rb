class Game < ActiveRecord::Base
  belongs_to :division
  has_many :matchups
  has_many :teams, :through => :matchups
  belongs_to :location
  has_many :availabilities
  #belongs_to :snack_volunteer,:class_name => "Participant", :foreign_key => "snack_volunteer_id"
  
  has_many :game_reports
  
  include CirclesScheduler
  
  # Instance Methods
  def allDay
    false
  end
  
  def title
    titleText = self.start.strftime("%l:%M%p")
    if self.assigned?
      titleText += " #{teams[0].display_name} vs. #{teams[1].display_name}"
    else
      titleText += " Practice/Scrimmage "
    end
    if self.location
      titleText += " @ #{location.name}"
    end
    return titleText
  end
  
  def send_game_reminders
    teams.each{ |team|
         team.participants.each{ |p|
            p.send_game_reminder(self) if p
          } if team
    } if teams
  end
  
  def start
    scheduled_at
  end

  def email_title
    titleText = self.start.in_time_zone(self.division.program.hub.time_zone).strftime("%l:%M%p")
    if self.assigned?
      titleText += " #{teams[0].display_name} vs. #{teams[1].display_name}"
    else
      titleText += " Practice/Scrimmage "
    end
    if self.location
      titleText += " @ #{location.name}"
    end
    return titleText
  end
  
  def className
    self.assigned? ? "assigned" : "unassigned"
  end
  
  def eventType
    "Game"
  end
  
  def home_team
    home_team = nil
    matchups.each do |matchup|
      if matchup.home_or_away == "Home"
        home_team = matchup.team
      end
    end
    home_team
  end

  def away_team
    away_team = nil
    matchups.each do |matchup|
      if matchup.home_or_away == "Away"
        away_team = matchup.team
      end
    end
    away_team
  end
  
  def update_from_params(params)
    update_scheduled_at(params[:game_date], params[:game_time])
    if self.teams
      self.teams.clear
    end
    home_team = Team.find(params[:home_team])
    away_team = Team.find(params[:away_team])
    matchup = Matchup.create_new_matchups(self, home_team, away_team)
    
    location = Location.find(params[:location])
    self.location = location
    self.save!
  end
  
  def get_availability(participant)
    availability = nil
    availability = availabilities.find_by_participant_id(participant.id) 
    if !availability || availability.available
      return true
    else
      return false
    end
  end
  
  def set_snack_volunteer(team, participant)
    self.matchups.each do |m|
      if m.team == team
        if participant
          m.snack_volunteer_id = participant.id
        else
          m.snack_volunteer_id = nil
        end
        m.save!
      end
    end
  end
  
  def snack_volunteer(team)
    snack_volunteer_participant = nil
    self.matchups.each do |m|
      if m.team == team && m.snack_volunteer_id 
        snack_volunteer_participant = Participant.find(m.snack_volunteer_id)
      end
    end
    snack_volunteer_participant
  end
        
  def other_team(team)
    self.matchups.each do |m|
      if m.team != team
        return m.team
      end
    end
  end
  
  def is_preseason?
    num_preseason_games = self.division.preseason_games
    if num_preseason_games > 0
    	self.home_team.games[0..num_preseason_games-1].include?(self)
    else
        false
    end
  end
  
  def is_interlock?
    self.home_team.is_external && self.away_team.is_external
  end
  
  def is_for_current_session?
    self.home_team.active_session
  end
  
  def set_date_time(game_date, game_time)
    self.scheduled_at = change_calendar_slot(self.scheduled_at, game_date, game_time)
  end
  
  def final_score
    home_team_game_report = self.home_team.game_report(self) 
    confirmed_game_report = home_team_game_report ? home_team_game_report : self.away_team.game_report(self)
    if confirmed_game_report
      "#{confirmed_game_report.home_team_score} - #{confirmed_game_report.away_team_score}"
    else
      "No Score Yet"
    end
  end
  
  def winning_team
    winning_team = nil
    confirmed_game_report = self.home_team.game_report(self)
    if confirmed_game_report
      if confirmed_game_report.home_team_score > confirmed_game_report.away_team_score
        winning_team = self.home_team
      elsif confirmed_game_report.home_team_score < confirmed_game_report.away_team_score
        winning_team = self.away_team
      end
    end
    winning_team
  end
  
  protected
  def assigned?
    if self.teams && self.teams.size == 2 && self.home_team != self.away_team
      return true
    else
      return false
    end
  end
  
  def update_scheduled_at(new_date, new_time)
    self.scheduled_at = change_calendar_slot(self.scheduled_at, new_date, new_time)
  end
  
end
