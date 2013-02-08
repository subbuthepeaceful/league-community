require 'config/environment'

namespace :lamvpb do
  task :create_external_team_roster do
    
    MAX_ROSTER_SIZE = 13
    
    hub = Hub.find_by_url_prefix('lamvpb')
    session = hub.default_program.currently_active_session
    division = Division.find_by_name(ENV['DIVISION'])
    
    division.teams.each do |team|
      if team.session == session && team.is_external
        # Need to seed a roster
        
        puts "Setting up #{team.name}"
        # First create a head coach
        c = Contact.new
        c.first_name = "Coach"
        c.last_name = "#{team.name}"
        c.save!
        
        i = 1
        while i <= MAX_ROSTER_SIZE 
        
          p = Participant.new
          p.first_name = "Player#{i}"
          p.last_name = "#{team.name}"
          
          p.hubs << hub
          p.contacts << c
          p.save!
          
          r = Registration.new
          r.session = session
          r.division = division
          r.participant = p
          r.save!
          
          i += 1
        end
      end
    end
  end
  task :create_external_roster_for_single_team do
    
    MAX_ROSTER_SIZE = 13
    
    hub = Hub.find_by_url_prefix('lamvpb')
    session = hub.default_program.currently_active_session
    division = Division.find_by_name(ENV['DIVISION'])

    team = Team.find(ENV['TEAM_ID'])
    
      if team.session == session && team.is_external
        # Need to seed a roster
        
        puts "Setting up #{team.name}"
        # First create a head coach
        c = Contact.new
        c.first_name = "Coach"
        c.last_name = "#{team.name}"
        c.save!
        
        i = 1
        while i <= MAX_ROSTER_SIZE 
        
          p = Participant.new
          p.first_name = "Player#{i}"
          p.last_name = "#{team.name}"
          
          p.hubs << hub
          p.contacts << c
          p.save!
          
          r = Registration.new
          r.session = session
          r.division = division
          r.participant = p
          r.save!
          
          i += 1
        end
    end
  end
end
