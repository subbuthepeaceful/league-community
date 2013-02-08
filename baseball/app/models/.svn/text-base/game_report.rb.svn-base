class GameReport < ActiveRecord::Base
  belongs_to :team
  belongs_to :game
  belongs_to :contact
  
  has_many :game_statistics, :dependent => :destroy
  has_many :star_player_votes, :dependent => :destroy
  
  validates_numericality_of :home_team_score
  
  validates_numericality_of :away_team_score
  
  validates_numericality_of :num_innings_played
  
  validate :number_of_innings_greater_than_zero
  validate :home_team_score_greater_than_zero
  validate :away_team_score_greater_than_zero
  
  validates_presence_of :actual_end_time

  include CirclesScheduler
    
  # Class Methods
  def self.create_from_params(team, game, contact, params)
    gr = GameReport.new
    gr.team = team
    gr.game = game
    gr.contact = contact
    gr.actual_start_date = params[:actual_start_date]
    gr.home_team_score = params[:home_team_score]
    gr.away_team_score = params[:away_team_score]
    gr.num_innings_played = params[:num_innings_played]
    gr.end_reason = params[:end_reason]
    gr.plate_umpire = params[:plate_umpire]
    gr.field_umpire = params[:field_umpire]
    gr.comments = params[:comments]
    gr.set_actual_game_start_end(params[:actual_start_time], params[:actual_end_time])
    
    gr.state = "In Process"
    gr
  end
  
  # Instance Methods  
  def confirmed?
    self.state == "Confirmed"
  end
  def update_from_params(team, game, contact, params)
    self.team = team
    self.game = game
    self.contact = contact
    self.actual_start_date = params[:actual_start_date]
    self.home_team_score = params[:home_team_score]
    self.away_team_score = params[:away_team_score]
    self.num_innings_played = params[:num_innings_played]
    self.end_reason = params[:end_reason]
    self.plate_umpire = params[:plate_umpire]
    self.field_umpire = params[:field_umpire]
    self.comments = params[:comments]
    self.set_actual_game_start_end(params[:actual_start_time], params[:actual_end_time])
    
    self.state = "In Process"
    self
  end
  
  
  def set_actual_game_start_end(start_time, end_time)
    self.actual_start_time = create_calendar_entry(self.actual_start_date, start_time)
    self.actual_end_time = create_calendar_entry(self.actual_start_date, end_time)
  end
  
  def save_statistics(params)
    #Presumably we get individual statistics per participant
    team.players.each_with_index do |p,i|
      #Pitching Statistics
      key1 = "pitcher_#{i}".to_sym
      key2 = "innings_#{i}".to_sym
      key3 = "pitches_#{i}".to_sym
      unless params[key1].blank?
        # We have an entry for this player
        game_statistic = GameStatistic.new
        game_statistic.game_report = self
        game_statistic.participant = p
        game_statistic.statistic_name = "Pitching Order|Innings|Count"
        game_statistic.statistic_value = params[key1] + "|" + params[key2] + "|" + params[key3]
        game_statistic.save!
      end
      key4 = "catches_#{i}".to_sym
      unless params[key4].blank?
        # We have a catching entry for this player
        game_statistic = GameStatistic.new
        game_statistic.game_report = self
        game_statistic.participant = p
        game_statistic.statistic_name = "Catching Innings"
        game_statistic.statistic_value = params[key4]
        game_statistic.save!
      end
    end
  end
  
  def decompose_statistics
    @statistics_array = []
    game_statistics.each do |gs|
      @statistic_line = Hash.new
      @statistic_line[:player] = gs.participant
      if gs.statistic_name == "Pitching Order|Innings|Count"
        pitching_stats = gs.statistic_value.split("|")
        @statistic_line[:pitcher_number] = pitching_stats[0]
        @statistic_line[:innings_pitched] = pitching_stats[1]
        @statistic_line[:pitch_count] = pitching_stats[2]
      elsif gs.statistic_name == "Catching Innings"
        @statistic_line[:innings_caught] = gs.statistic_value
      end
      @statistics_array << @statistic_line 
    end
    @statistics_array
  end
  
  def clear_statistics
    game_statistics.clear
  end
  
  def save_star_player_votes(params)
    unless params[:first_vote].blank?
      new_star_player_vote(params[:first_vote], 1)
    end
    unless params[:second_vote].blank?
      new_star_player_vote(params[:second_vote], 2)
    end
    unless params[:third_vote].blank?
      new_star_player_vote(params[:third_vote], 3)
    end
  end
  
  def clear_star_player_votes
    star_player_votes.clear
  end
  
  def first_vote
    star_player_vote(1)
  end
  
  def second_vote
    star_player_vote(2)
  end
  
  def third_vote
    star_player_vote(3)
  end
  
  def process_notifications
    # The Game Report Theoretically needs to be sent to The Coach and the Division Director
    recipients = Array.new
    recipients << self.contact
    admin_roles = self.team.division.resolve_admin_roles
    admin_roles.each do |admin_role|
      recipients << admin_role.contact
    end
    if EMAIL_ENABLED      
      UserMailer.deliver_game_report(self, recipients)
    end
  end
  
  def send_contact_notifications
    # The Game Report Theoretically needs to be sent to The Coach and the Division Director
    recipients = Array.new
    recipients << self.contact
    UserMailer.deliver_game_report(self, recipients)
  end
  
  # Validation Methods
  def number_of_innings_greater_than_zero
    if num_innings_played && num_innings_played == 0 
      errors.add "num_innings_played", "should be greater than zero"
    end
  end

  def home_team_score_greater_than_zero
    if home_team_score && home_team_score < 0 
      errors.add "home_team_score", "should be 0 or more"
    end
  end

  def away_team_score_greater_than_zero
    if away_team_score && away_team_score < 0 
      errors.add "away_team_score", "should be 0 or more"
    end
  end
  
  def star_player_vote(rank)
    star_player_votes.each do |spv|
      if spv.vote_rank == rank
        return spv.participant
      end
    end
    return nil
  end
  
  def new_star_player_vote(param, rank)
    star_player_vote = StarPlayerVote.new
    star_player_vote.game_report = self
    star_player_vote.participant = Participant.find(param)
    star_player_vote.vote_rank = rank
    star_player_vote.save!
  end
  
  # Standings Helper Methods
  def is_tie?
    home_team_score == away_team_score
  end
  
  def winning_team
    home_team_score > away_team_score ? :home : :away
  end

  def score(home_or_away)
    home_or_away == :home ? home_team_score : away_team_score
  end
  
  def other_score(home_or_away)
    home_or_away == :home ? away_team_score : home_team_score
  end
  
end