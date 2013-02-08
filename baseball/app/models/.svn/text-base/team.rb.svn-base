class Team < ActiveRecord::Base
  belongs_to :division
  belongs_to :session
  has_many :team_memberships
  has_many :participants, :through => :team_memberships, :order => :last_name
  has_many :matchups
  has_many :games, :through => :matchups

  has_one :sponsorship, :as => :sponsorable, :dependent => :destroy
  
  has_attached_file :logo, :styles => { :thumb => "86x76#", :small => "178x152" }
  
  has_many :game_reports
  has_one :team_record

  # Instance Methods
  def active_session
    session.status == "Active"
  end
  
  def update_roster(participant_id_list)
    participants.each do |participant|
      unless participant_id_list.split(",").include?(participant.id.to_s)
        participants.delete(participant)
      end
    end
    participant_id_list.split(",").each do |participant_id|
      participant = Participant.find(participant_id)
      add_participant(participant)
    end
  end
  
  def add_participant(participant)
    unless participants.include?(participant)
      participants << participant
    end
    save!
  end
  
  def assign_coach_from_params(contact_id, role)
    contact = Contact.find(contact_id)
    participants = contact.find_participants_for_team_division(division, self.session)
    participants.each do |participant|
      tm = TeamMembership.new
      tm.team = self
      tm.participant = participant
      tm.role = role
      tm.save
    end
  end    
  
  def head_coach
    head_coach = nil
    team_memberships.each do |team_membership|
      if team_membership.role == "Head Coach"
        head_coach = team_membership.participant.primary_contact
        break
      end
    end
    head_coach
  end
  
  def assistant_coaches
    assistant_coaches = Array.new
    team_memberships.each do |team_membership|
      if team_membership.role == "Assistant Coach"
        assistant_coaches << team_membership.participant.primary_contact
      end
    end
    assistant_coaches
  end
  
  def players
      players = Array.new
      team_memberships.each do |team_membership|
        #unless team_membership.role
        unless team_membership.participant.first_name == "N/A"
          players << team_membership.participant
        end
        #end
      end
      players.sort { |a,b|  a.last_name <=> b.last_name}
  end
  
  def size
    participants.size
  end
  
  def send_circles_message(circles_message)
    participants.each do |participant|
      participant.send_circles_message(circles_message, self)
    end
  end
  
  def set_selected_name(selected_name)
    self.selected_name = selected_name
    self.save!
  end
  
  def display_name
    display_name = self.name
    if self.selected_name
      display_name += " (#{self.selected_name})"
    end
    display_name
  end
  
  def update_team_logo(logo)
    self.logo = logo
    self.save!
  end
  
  def has_game_report(game)
    game_reports.each do |gr|
      if gr.game == game 
        return true
      end
    end
    return false
  end
  
  def has_confirmed_game_report(game)
    game_reports.each do |gr|
      if gr.game == game && gr.confirmed?
        return true
      end
    end
    return false
  end

  def has_saved_game_report(game)
    game_reports.each do |gr|
      if gr.game == game
        return true
      end
    end
    return false
  end
  
  def game_report(game)
    game_reports.each do |gr|
      if gr.game == game
        return gr
      end
    end
    return nil
  end
  
  def update_jersey_numbers(params)
    self.players.each_with_index do |p,i|
      key = "jersey_#{i}".to_sym
      if params[key]
        p.set_jersey_number(self, params[key])
      end
    end
  end
  
  def update_player_names_and_jerseys(params)
    self.players.each_with_index do |p,i|
      first_name_key = "first_name_#{i}".to_sym
      last_name_key = "last_name_#{i}".to_sym
      if params[first_name_key] && params[last_name_key]
        p.set_full_name(params[first_name_key], params[last_name_key])
      end
      jersey_number_key = "jersey_#{i}".to_sym
      if params[jersey_number_key]
        p.set_jersey_number(self, params[jersey_number_key])
      end
    end
  end
  
  # Team Records
  def update_team_record(game_report, home_or_away)
    unless self.team_record
      @team_record = TeamRecord.new
      @team_record.team = self
      @team_record.save!
    end
    @team_record.games_played += 1
    if game_report.is_tie?
      # This game ended in a tie
      @team_record.ties += 1
    else
      # This game had a result
      winning_team = game_report.winning_team
      if winning_team == home_or_away
        # This team is the winner
        @team_record.wins += 1
      else
        @team_record.losses += 1
      end
    end
    @team_record.runs_for += game_report.score(home_or_away)
    @team_record.runs_against += game_report.other_score(home_or_away)
    
    # Update Winning Pct
    @team_record.win_pct = (@team_record.wins.to_f + (@team_record.ties.to_f * 0.5)) / @team_record.games_played.to_f
    @team_record.save!
  end
  
  # Class Methods
  def self.create_team_for_program_division(program, division, params)
    team = Team.new
    team.name = params[:name]
    team.session = program.currently_active_session
    team.division = division
    team.save!
  end
  
end
