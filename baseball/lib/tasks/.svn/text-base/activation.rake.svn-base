require 'config/environment'

namespace :hubs do
  task :activate_online_access do
    division = Division.find(1)
    session = division.program.currently_active_session
    program = division.program
    hub = program.hub
    subject = "Welcome to the #{division.name} for the #{session.name} of #{program.name} at the #{hub.name}"
    division.activate_online_access(subject, "")
  end
end

namespace :lamvpb do
  task :activate_coaching_staff do

    hub = Hub.find_by_url_prefix('lamvpb')
    hub.default_program.divisions.each do |d|
	puts "Activating coaching staff for #{d}"
        d.head_coaches.each do |hc|
          if hc.user
            hc.resend_activation
          else
            hc.activate_online_access
          end
        end
    end
  end
end
