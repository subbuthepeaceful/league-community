class UserMailer < ActionMailer::Base
  def activate_notification(user, password, division, session, program, hub, participant, subject, message)
    #@from = "#{hub.url_prefix}@strongcircles.com"
    @from = "#{hub.from_email}"
    @recipients = "#{user.email}"
    @subject = "Welcome to the community at #{hub.name}"
    if hub.full_circles_domain
      fully_qualified_domain = hub.full_circles_domain
    else
      fully_qualified_domain = "#{hub.url_prefix}.#{DOMAIN}"
    end
    body[:user] = user
    body[:password] = password 
    body[:participant] = participant 
    body[:message] = message 
    body[:hub] = hub 
    body[:program] = program 
    body[:session] = session 
    body[:division] = division
    body[:domain] = fully_qualified_domain
    body[:activation_url] = activate_user_url(user, {:host => fully_qualified_domain})
  end
  
  def circles_message(contact, team, participant, circles_message)
    #@from = "#{circles_message.contact.name}-#{team.display_name}@support.strongcircles.com"
    team_sender = circles_message.contact.name.gsub(/[ ]/, '_') + "-" + team.display_name.gsub(/[ ]/, '_') + "@strongcircles.com"
    hub = team.division.program.hub
    @from = "#{hub.url_prefix}@strongcircles.com"
    @recipients = "#{contact.user.email}"
    @subject = "[#{team.session.name}/#{hub.name}|#{team.display_name}]: #{circles_message.subject}"
    fully_qualified_domain = "#{team.session.program.hub.url_prefix}.#{DOMAIN}"
    body[:participant] = participant
    body[:team] = team
    body[:message] = circles_message
    body[:domain] = fully_qualified_domain
    body[:participant_dashboard_url] = dashboard_participant_url(participant, {:host => fully_qualified_domain})
  end
  
  def game_reminder(user, game,participant)
      hub = game.division.program.hub
      @from = "#{hub.url_prefix}@strongcircles.com"
      @recipients = "#{user.email}"
      @subject = "Reminder from Strong Circles: Upcoming [#{game.email_title}/#{hub.name}]"
      body[:user] = user
      body[:participant] = participant 
      body[:hub] = hub 
      body[:game] = game
      body[:program] = game.division.program
      body[:division] = game.division
      fully_qualified_domain = "#{game.division.program.hub.url_prefix}.#{DOMAIN}"
      body[:domain] = fully_qualified_domain
      body[:participant_dashboard_url] = dashboard_participant_url(participant, {:host => fully_qualified_domain})
  end
  
  def reset_password_notification(user, password, hub)
    #@from = "#{hub.url_prefix}@strongcircles.com"
    @from = "#{hub.from_email}"
    @recipients = "#{user.email}"
    @subject = "Resetting your password for #{hub.name}"
    if hub.full_circles_domain
      fully_qualified_domain = hub.full_circles_domain
    else
      fully_qualified_domain = "#{hub.url_prefix}.#{DOMAIN}"
    end
    body[:user] = user
    body[:password] = password
    body[:hub] = hub
    body[:domain] = fully_qualified_domain
    body[:activation_url] = activate_user_url(user, {:host => fully_qualified_domain})
  end
  
  def sponsorship_thank_you_notification(hub, sponsor, sponsored_option, sponsorship_option, operating_domain)
    @from = "#{hub.from_email}"
    @recipients = "#{sponsor.contact_email}"
    @subject = "#{hub.name} : Thank you for your sponsorship"
    body[:domain] = operating_domain
    body[:hub] = hub
    body[:sponsor] = sponsor
    body[:sponsored_option] = sponsored_option
    body[:sponsorship_option] = sponsorship_option
  end
  
  def new_sponsorship_notification(hub, sponsor, sponsored_option, sponsorship_option, operating_domain)
    @from = "#{hub.from_email}"
    @recipients = "#{hub.sponsor_email}"
    @subject = "#{hub.name} : A new online sponsorship has been created"
    body[:domain] = operating_domain
    body[:hub] = hub
    body[:sponsor] = sponsor
    body[:sponsored_option] = sponsored_option
    body[:sponsorship_option] = sponsorship_option
  end
  
  def game_report(game_report, recipients)
    hub = game_report.team.division.program.hub
    @from = "#{hub.from_email}"
    @recipients = (recipients.collect { |r| r.email_address}).join(",")
    
    # Special Cases
    unless game_report.team.division.name == "Pinto-2"
      @recipients += ",umpires@lamvpb.org"
    end
    
    #if game_report.game.home_team.division.name == "Bronco"
    #  @recipients += ",mark.atherton@oracle.com"
    #end
    
    #@recipients = "bsubbu@sbcglobal.net"
    @subject = "Game Report: #{game_report.game.away_team.selected_name} @ #{game_report.game.home_team.selected_name} : #{game_report.game.scheduled_at.to_s(:circles_scheduled_event)}"
    if hub.full_circles_domain
      fully_qualified_domain = hub.full_circles_domain
    else
      fully_qualified_domain = "#{hub.url_prefix}.#{DOMAIN}"
    end
    body[:game_report] = game_report
    body[:team] = game_report.team
    body[:game] = game_report.game
    body[:game_statistics] = game_report.decompose_statistics
  end
end
