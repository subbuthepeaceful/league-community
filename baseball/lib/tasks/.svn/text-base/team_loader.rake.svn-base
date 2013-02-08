require 'config/environment'

namespace :lamvpb do
  task :load_registrations do 
    file = ENV['ROSTER_FILE']
    
    hub = Hub.find_by_url_prefix('lamvpb')
    session = hub.default_program.currently_active_session
    division = Division.find_by_name(ENV['DIVISION'])
    
    roster_file = "#{ROSTER_PATH}/#{CURRENT_SEASON}/#{file}"
    roster_file_handle = File.open(roster_file)
    while roster_line = roster_file_handle.gets do
      roster_line_parts = roster_line.strip.split(",")
    
      puts "Looking for Contact '#{roster_line_parts[2]}'"
      c = Contact.find_by_email_address(roster_line_parts[2])
      if c.nil?
        # We do not have this contact already
        c = Contact.new
        c.first_name = "<Parent>"
        c.last_name = roster_line_parts[1]
        c.email_address = roster_line_parts[2]
        c.save!
        puts "Creating Contact #{roster_line_parts[2]}"
      else
        puts "Found Contact #{c.email_address}"
      end
      
      p = c.participants.find_by_first_name(roster_line_parts[0])
      if p.nil?
        # We do not have this participant already
        p = Participant.new
        p.first_name = roster_line_parts[0]
        p.last_name = roster_line_parts[1]
        
        p.contacts << c
        p.hubs << hub
        
        p.save!
        
        puts "Creating new participant #{p.first_name}"
      else
        puts "Found Participant #{p.first_name}"
      end
      
      # Now we have a contact and participant identified
      r = Registration.new
      r.participant = p
      r.division = division
      r.session = session
      r.save!
      
      puts "Adding registration..."
    end
  end
end