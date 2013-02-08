class Division < ActiveRecord::Base
  belongs_to :program
  has_many :teams 
  has_many :registrations
  has_many :games
  has_many :events
  
  include CirclesScheduler
  
  # Instance Methods
  def teams_for_session(session)
    teams.select { |t| t.session == session }
  end
  
  def registrations_for_session(session)
    registrations.select { |r| r.session == session }
  end
  
  def to_s
    name
  end
  
  def start_date
    program.currently_active_session.start_date
  end
  
  def start_date_year
    start_date.to_formatted_s(:year_only)
  end
  
  def start_date_month
    start_date.to_formatted_s(:month_only)
  end
  
  def start_date_month_as_offset
    MONTHS_OF_THE_YEAR.index(start_date_month)
  end
  
  def create_weekly_schedule_from_params(params)
    location = Location.find(params[:location])
    DAYS_OF_THE_WEEK.each do |day_name|
      if params[day_name.to_sym]
        puts "Found weekly time slots for #{day_name}"
        i = 1
        time_slot_index = "#{day_name}_slot_#{i}"
        while params[time_slot_index.to_sym]
          time_slot = params[time_slot_index.to_sym]
          puts "Found new time slot for #{day_name} : #{time_slot}"
          repeating_game_slots = create_calendar_slots(program.currently_active_session.start_date, program.currently_active_session.end_date, day_name, time_slot)
          repeating_game_slots.each do |rgs|
            game = Game.new
            game.division = self
            game.scheduled_at = rgs
            game.location = location
            game.save
          end
          i += 1
          time_slot_index = "#{day_name}_slot_#{i}"
        end
      end
    end
    self.has_schedule = true
    self.save!
  end
  
  def activate_online_access(subject, message)
    registrations.each do |registration|
      p = registration.participant
      p.activate_online_access(registration, subject, message)
      puts "Sending mail and activating #{p.name}"
    end
  end
  
  def calendar(team=nil,include_games=true,include_events=true)
    calendar = Array.new
    if include_games
      if team
        games = self.games.sort { |x,y| x.start <=> y.start}
        games.each{|game|
            if game
                calendar << game if game.teams.include?(team)
            end
        }
      else
        calendar << self.games
      end
    end
    calendar << self.events if include_events
    calendar << self.program.currently_active_session.events if include_events
    calendar.flatten!
    calendar
  end
    
  def scheduled_games
    scheduled_games = []
    games.each do |game|
      if game.matchups.size > 0 && game.is_for_current_session?
        scheduled_games << game
      end
    end
    scheduled_games.sort! { |a,b| a.scheduled_at <=> b.scheduled_at}
  end

  def all_games
    all_games = []
    games.each do |game|
      if game.matchups.size > 0 
        all_games << game
      end
    end
    all_games.sort! { |a,b| a.scheduled_at <=> b.scheduled_at}
  end
  
  def resolve_admin_roles
    admin_roles = AdminRole.find(:all, :conditions => "admin_classification = 'Division' and admin_instance = '#{self.id}'")
    admin_roles
  end
  
  def head_coaches
    head_coach_array = []
    self.teams.each do |team|
      if team.active_session
      	head_coach_array << team.head_coach 
       end
    end
    head_coach_array
  end
  
  def external?
    external
  end
  
  def top_voted_players
    voted_players = []
    self.teams.each do |team|
      if team.active_session 
        team.players.each do |player|
          current_star_player_votes = player.current_star_player_votes(team)
          if current_star_player_votes && current_star_player_votes.size > 0
            voted_player = Hash.new
            voted_player[:player] = player
            voted_player[:num_votes] = current_star_player_votes.size
            voted_player[:team] = team
            voted_player[:voted_games] = current_star_player_votes.collect { |v| v.game_report }
            if self.preseason_games > 0
              voted_player[:regular_season_votes] = player.regular_season_votes.size
            end
            voted_players << voted_player
          end
        end
      end
    end
    voted_players.sort! { |p1, p2| p2[:num_votes] <=> p1[:num_votes]}
    voted_players
  end
  
  # Class Methods
  
  def self.create_division_for_program(program, session, params)
    division = Division.new
    division.name = params[:name]
    division.team_prefix = params[:team_prefix]
    division.description = params[:description]
    division.age_range = params[:age_range]
    division.program = program
    
    division.save!
    
    for i in 1..params[:number_of_teams].to_i
      t = Team.new
      t.name = "#{division.team_prefix}-#{i}"
      t.division = division
      t.session = session
      t.save
    end
  end
  
  def self.identify_or_create(program, session, division)
    division = program.divisions.find_by_name(division)
  end  
  
end

