require 'csv'

CLUB_PREFIX = "Red Star SA "

namespace :club_setup do
  task :load_seed_data => :environment do
    #load_age_groups
    #load_fields
    #load_teams
    #load_game_slot_patterns
    #create_game_slots_on_fields
  end

  task :fix_slots_for_utc => :environment do
    GameSlot.all.each do |game_slot|
        abs_utc_offset = game_slot.game_date_time.utc_offset.abs
        game_slot.game_date_time = game_slot.game_date_time.advance(:seconds => abs_utc_offset)
        if abs_utc_offset == 25200
            # Daylight savings time
            game_slot.game_date_time = game_slot.game_date_time.advance(:hours => 1)
        end
        game_slot.save!
    end
  end

  task :fix_field_slots_for_utc => :environment do
    field = Field.find_by_name(ENV['FIELD'])
    puts "Processing Field #{field.name}"
    field.game_slots.each do |game_slot|
        abs_utc_offset = game_slot.game_date_time.utc_offset.abs
        game_slot.game_date_time = game_slot.game_date_time.advance(:seconds => abs_utc_offset)
        if abs_utc_offset == 25200
            # Daylight savings time
            game_slot.game_date_time = game_slot.game_date_time.advance(:hours => 1)
        end
        game_slot.save!
    end
  end

  task :fix_field_slots_for_dst => :environment do
    field = Field.find_by_name(ENV['FIELD'])
    puts "Processing Field #{field.name}"
    field.game_slots.each do |game_slot|
        abs_utc_offset = game_slot.game_date_time.utc_offset.abs
        if abs_utc_offset == 28800
            # NOT Daylight savings time
            game_slot.game_date_time = game_slot.game_date_time.advance(:hours => 1)
        end
        game_slot.save!
    end
  end

  task :fix_fifteen_minutes => :environment do
    field = Field.find_by_name(ENV['FIELD'])
    puts "Processing Field #{field.name}"
    field.game_slots.each do |game_slot|
        slot_hour = game_slot.game_date_time.hour
        if (slot_hour == 14 || slot_hour == 15 || slot_hour == 17)
            #Afternoon slot
            game_slot.game_date_time = game_slot.game_date_time.advance(:minutes => 15)
        end
        game_slot.save!
    end
  end

  task :create_game_slots_on_fields => :environment do

    fall_2012_season = Season.find_by_name('Fall 2012 Season')
    saturday_8v8_slots = GameSlotPattern.find_by_day_of_the_week_and_duration('Saturday', 75)
    sunday_8v8_slots = GameSlotPattern.find_by_day_of_the_week_and_duration('Sunday', 75)
    sunday_11v11_slots = GameSlotPattern.find_by_day_of_the_week_and_duration('Sunday', 120)

    # Montclaire BIG
    montclaire_big = Field.find_by_name('Montclaire BIG')
    GameSlot.create_from_pattern_for_season(saturday_8v8_slots, fall_2012_season, montclaire_big)
    GameSlot.create_from_pattern_for_season(sunday_8v8_slots, fall_2012_season, montclaire_big)

    # Montclaire SMALL
    montclaire_small = Field.find_by_name('Montclaire SMALL')
    GameSlot.create_from_pattern_for_season(saturday_8v8_slots, fall_2012_season, montclaire_small)
    GameSlot.create_from_pattern_for_season(sunday_8v8_slots, fall_2012_season, montclaire_small)

    # Slater Field
    slater_field = Field.find_by_name('Slater Field')
    GameSlot.create_from_pattern_for_season(sunday_8v8_slots, fall_2012_season, slater_field)

    # Whisman Park
    whisman_park = Field.find_by_name('Whisman Park')
    GameSlot.create_from_pattern_for_season(sunday_11v11_slots, fall_2012_season, whisman_park)     

  end

  task :list_season_schedule => :environment do
    current_season_schedule_files = FileList.new("#{Rails.root}/db/data/seasons/test/*.csv")
    current_season_schedule_files.each do |game_day_file|
        puts game_day_file
    end
  end


  task :load_season_schedule => :environment do
        #current_season_schedule_file = File.open("#{Rails.root}/db/data/seasons/current_season.csv")
        current_season_schedule_files = FileList.new("#{Rails.root}/db/data/seasons/current/*.csv")
        @active_game_date = nil
        @teams = Team.all
        current_season_schedule_files.each do |schedule_file|
            puts "Processing #{schedule_file}"
            game_date_game_file = File.open(schedule_file)
            CSV.foreach(game_date_game_file) do |row|
                if row[2] && game_date_parts = row[2].match(/(\w+)[ ]*(\d+)[,][ ]*(\d+)/)
                    @active_game_date = "#{game_date_parts[3]}-#{convert_month(game_date_parts[1])}-#{game_date_parts[2]}"
                end
                #puts "Processing #{row.to_s}"
                # This is a new game
                if @active_game_date && row[2]
                    game = Game.new
                    game.external_id = row[0]
                    game.game_date = @active_game_date
                    possible_home_team = determine_club_team(@teams, row[7])
                    if possible_home_team
                      game.is_home_game = true
                      game.team = possible_home_team
                      game.opponent = row[9]
                    end
                    possible_away_team = determine_club_team(@teams, row[9])
                    if possible_away_team 
                      if game.team
                        # This is a game betwen two Red Star teams
                        @second_game = Game.new
                        @second_game.external_id = row[0]
                        @second_game.game_date = @active_game_date

                        @second_game.team = possible_away_team
                        @second_game.is_home_game = false
                        @second_game.opponent = row[7]

                        @second_game.division = row[11]
                        @second_game.league = row[12]
                        @second_game.comments = row[3]
                        @second_game.save!
                      else

                        game.is_home_game = false
                        game.team = possible_away_team
                        game.opponent = row[7]
                      end
                    end
                    game.division = row[10]
                    game.league = row[11]
                    game.comments = row[4]
                    game.location = row[6]

                    # Now lets figure out game times
                    if row[3] && row[3].length > 0
                        time_parts = row[3].match(/(\d+)[:]*(\d+)*[ ]*(AM|PM|am|pm)/)
                        if time_parts
                            game.game_time = game.game_date

                            game.game_time = game.game_time.advance(:hours => time_parts[1].to_i, :minutes => time_parts[2].to_i)
                            if time_parts[3].upcase == "PM" && time_parts[1].to_i != 12
                                game.game_time = game.game_time.advance(:hours => 12)
                            end

                            if Rails.env == "production"
                                abs_utc_offset = game.game_time.utc_offset.abs
                                game.game_time = game.game_time.advance(:seconds => abs_utc_offset)
                                if abs_utc_offset == 25200
                                    # Daylight savings time
                                    game.game_time = game.game_time.advance(:hours => 1)
                                end
                            end
                        else
                            puts "Unable to resolve time for #{game.external_id}"
                        end
                    end

                    if game.is_home_game
                        # Now lets find home fields
                        home_fields = game.team.age_group.fields
                        if row[6] && row[6].length > 0
                            possible_home_field = home_fields.select { |h| ((h.name == row[6]) || (h.name.downcase =~ /#{row[6].downcase}/)) }[0]
                            if possible_home_field 
                                if game.game_time
                                    possible_game_slot = possible_home_field.game_slots.select { |gs| gs.game_date_time == game.game_time }[0]
                                    if possible_game_slot
                                        #puts "#{game.external_id} ON #{possible_home_field.name} @ #{possible_game_slot.game_date_time}"
                                        game.game_slot = possible_game_slot
                                    else
                                        puts "#{game.external_id} ON #{possible_home_field.name} #{game.game_time}@ NO SLOT FOUND"
                                    end
                                else
                                    game.comments = (game.comments ? game.comments : " ") + " " + possible_home_field.name
                                end
                            else
                                #puts "#{game.external_id} CANNOT MAP TO #{row[5]}"
                                game.comments = (game.comments ? game.comments : " ") + " " + row[5]
                            end
                        end
                    end

                    #puts "New Game : #{game.to_json}"
                    if game.team
                        #puts "Saving Game #{game.external_id}"
                        game.save!
                    else
                      puts "Unable to resolve Team for #{game.to_json}"
                    end
                end
            end
        end
    end


  def determine_club_team(teams, h_or_a)
    teams.each do |team|
      if h_or_a.downcase.match((CLUB_PREFIX + team.name).downcase)
        return team
      end
    end
    return nil
  end

  def convert_month(str)
    case str
    when "Aug" 
        return "08"
    when "Sep"
        return "09"
    when "Oct"
        return "10"
    when "Nov"
        return "11"
    when "Dec"
        return "12"
    when "Jan"
        return "01"
    when "Feb"
        return "02"
    when "Mar"
        return "03"
    when "Apr"
        return "04"
    when "May"
        return "05"
    when "Jun"
        return "06"
    when "Jul"
        return "07"
    end
  end

  def load_age_groups
    # Age Groups:
    AgeGroup.delete_all
    u14 = AgeGroup.create(name: 'U14', team_size: '11v11', game_slot_duration: 90)
    u13 = AgeGroup.create(name: 'U13', team_size: '11v11', game_slot_duration: 90)
    u12 = AgeGroup.create(name: 'U12', team_size: '11v11', game_slot_duration: 90)
    u11 = AgeGroup.create(name: 'U11', team_size: '8v8', game_slot_duration: 75)
    u10 = AgeGroup.create(name: 'U10', team_size: '8v8', game_slot_duration: 75)
    u9 = AgeGroup.create(name: 'U9', team_size: '8v8', game_slot_duration: 75)
    u8 = AgeGroup.create(name: 'U8', team_size: '8v8', game_slot_duration: 75)
  end

  def load_fields
    # Fields
    Field.delete_all
    montclaire_big = Field.create(name: 'Montclaire BIG', location: 'Montclaire Elementary School', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    montclaire_small = Field.create(name: 'Montclaire SMALL', location: 'Montclaire Elementary School', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    grant_park = Field.create(name: 'Grant Park', location: 'Grant Park', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    slater_field = Field.create(name: 'Slater Field', location: 'Slater Elementary School', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    whisman_park = Field.create(name: 'Whisman Park', location: 'Whisman Park', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    hillview_field = Field.create(name: 'Hillview Field', location: 'Hillview Park', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
    rosita_field = Field.create(name: 'Rosita Field', location: 'Rosita Park', address: 'TO DO', instructions: 'GOAL SETUP/LOCK COMBINATIONS')
  end

  def load_teams

    u14 = AgeGroup.find_by_name('U14')
    u13 = AgeGroup.find_by_name('U13')
    u12 = AgeGroup.find_by_name('U12')
    u11 = AgeGroup.find_by_name('U11')
    u10 = AgeGroup.find_by_name('U10')
    u9 = AgeGroup.find_by_name('U9')
    u8 = AgeGroup.find_by_name('U8')

    # BOYS
    u14b_red = Team.create(name: '98B Red', gender: 'Boys', age_group: u14)
    u13b_red = Team.create(name: '99B Red', gender: 'Boys', age_group: u13)
    u13b_white = Team.create(name: '99B White', gender: 'Boys', age_group: u13)
    u12b_red = Team.create(name: '00B Red', gender: 'Boys', age_group: u12)
    u12b_white = Team.create(name: '00B White', gender: 'Boys', age_group: u12)
    u12b_black = Team.create(name: '00B Black', gender: 'Boys', age_group: u12)
    u11b_red = Team.create(name: '01B Red', gender: 'Boys', age_group: u11)
    u11b_white = Team.create(name: '01B White', gender: 'Boys', age_group: u11)
    u11b_black = Team.create(name: '01B Black', gender: 'Boys', age_group: u11)
    u11b_green = Team.create(name: '01B Green', gender: 'Boys', age_group: u11)
    u10b_red = Team.create(name: '02B Red', gender: 'Boys', age_group: u10)
    u10b_white = Team.create(name: '02B White', gender: 'Boys', age_group: u10)
    u10b_black = Team.create(name: '02B Black', gender: 'Boys', age_group: u10)
    u10b_green = Team.create(name: '02B Green', gender: 'Boys', age_group: u10)
    u9b_red = Team.create(name: '03B Red', gender: 'Boys', age_group: u9)
    u9b_white = Team.create(name: '03B White', gender: 'Boys', age_group: u9)
    u9b_black = Team.create(name: '03B Black', gender: 'Boys', age_group: u9)
    u9b_green = Team.create(name: '03B Green', gender: 'Boys', age_group: u9)
    u8b_red = Team.create(name: '04B Red', gender: 'Boys', age_group: u8)
    u8b_white = Team.create(name: '04B White', gender: 'Boys', age_group: u8)
    u8b_black = Team.create(name: '04B Black', gender: 'Boys', age_group: u8)
    u8b_green = Team.create(name: '04B Green', gender: 'Boys', age_group: u8)
    # GIRLS
    u11g_red = Team.create(name: '01G Red', gender: 'Girls', age_group: u11)
    u11g_white = Team.create(name: '01G White', gender: 'Girls', age_group: u11)
    u10g_red = Team.create(name: '02G Red', gender: 'Girls', age_group: u10)
    u10g_white = Team.create(name: '02G White', gender: 'Girls', age_group: u10)
    u9g_red = Team.create(name: '03G Red', gender: 'Girls', age_group: u9)
    u8g_red = Team.create(name: '04G Red', gender: 'Girls', age_group: u8)

  end

  def load_game_slot_patterns
    saturday_8v8_slots = GameSlotPattern.create(day_of_the_week: 'Saturday')
    sunday_8v8_slots = GameSlotPattern.create(day_of_the_week: 'Sunday')
    saturday_11v11_slots = GameSlotPattern.create(day_of_the_week: 'Saturday', duration: 90)
    sunday_11v11_slots = GameSlotPattern.create(day_of_the_week: 'Sunday', duration: 90)
  end

end
