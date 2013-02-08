require 'config/environment'

namespace :lamvpb do
  task :load_game_schedule do 
    file = ENV['SCHEDULE_FILE']
    
    hub = Hub.find_by_url_prefix('lamvpb')
    session = hub.default_program.currently_active_session
    division = Division.find_by_name(ENV['DIVISION'])

    game_schedule_file = "#{GAME_SCHEDULE_PATH}/#{CURRENT_SEASON}/#{file}"
    game_schedule_file_handle = File.open(game_schedule_file)
    game_schedule_file_handle.gets
    while schedule_line = game_schedule_file_handle.gets do
      schedule_line_parts = schedule_line.gsub(/"/, '').split(",")
      
      # Determine Teams
      puts schedule_line
      matchup_details = /([A-Z][(A-Z)|(0-9)]?\-[0-9][0-9])([ ])(.*)([ ])(vs\.)([ ])([A-Z][(A-Z)|(0-9)]?\-[0-9][0-9])([ ])(.*)/.match(schedule_line_parts[0])
      away_team = session.teams.find_by_name(matchup_details[1])
      home_team = session.teams.find_by_name(matchup_details[7])
      
      location = Location.find_by_name(schedule_line_parts[5])
      
      game = Game.new
      game.division = division
      game.location = location
      game.set_date_time(schedule_line_parts[1], schedule_line_parts[2])
      game.save!
      
      matchup = Matchup.create_new_matchups(game, home_team, away_team)

    end
    
    game_schedule_file_handle.close
  end
end