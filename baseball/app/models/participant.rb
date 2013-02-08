class Participant < ActiveRecord::Base
  has_and_belongs_to_many :hubs
  has_and_belongs_to_many :contacts
  has_many :registrations
  has_many :team_memberships
  has_many :teams, :through => :team_memberships
  has_many :photos, :dependent => :destroy, :order => 'created_at desc'
  
  has_attached_file :profile_photo, :styles => { :thumb => "97x111#", :small => "194x222" }
  
  has_many :game_statistics
  has_many :star_player_votes
  
  def name
    first_name + " " + last_name
  end
  
  def primary_contact
    contacts[0]
  end
  
  def team
    # Participant can currently only be on one active team
    if teams
      teams.each do |t|
        if t.active_session
          @default_team = t
        end
      end
    end
    @default_team
  end
  
  def default_registration
    # Participant only has one active registration
    if registrations
      registrations.each do |r|
        if r.session.status == "Active"
          @default_registration = r
        end
      end
    end
    @default_registration
  end
  
  def has_registration_for_division(division)
    has_registration_for_division = false
    registrations.each do |registration|
      if registration.division == division
        has_registration_for_division = true
        break
      end
    end
    has_registration_for_division
  end
  
  def has_registration_for_session(session)
    has_registration_for_session = false
    registrations.each do |registration|
      if registration.session == session
        has_registration_for_session = true
        break
      end
    end
    has_registration_for_session
  end
  
  def has_registration_for_division_and_session(division, session)
    has_registration = false
      registrations.each do |registration|
      if registration.session == session && registration.division == division
        has_registration = true
        break
      end
    end
    has_registration
  end
    
  
  def activate_online_access(registration, subject, message)
    
    # This method is meant to be called for batch activation
    primary_contact.activate_online_access(self, registration, subject, message)
  end
  
  def resend_activation
    # This method is meant to be called for someone who has already been activated but has lost the activation email
    registration = self.default_registration
    
    division = registration.division
    program = division.program
    session = program.currently_active_session
    hub = program.hub
    subject = "Welcome to the #{division.name} for the #{session.name} of #{program.name} at the #{hub.name}"
    
    primary_contact.resend_activation(self, registration, subject)
  end
    
  def activate
    
    # This method is meant to be called for individual activation from the admin front end
    registration = self.default_registration
    
    division = registration.division
    program = division.program
    session = program.currently_active_session
    hub = program.hub
    subject = "Welcome to the #{division.name} for the #{session.name} of #{program.name} at the #{hub.name}"

    primary_contact.activate_online_access(self, registration, subject, nil)
  end
  
  def send_game_reminder(game)
    primary_contact.send_game_reminder(self, game)
  end
  
  def programs
    programs = Array.new
    registrations.each do |registration|
      program = Hash.new
      program["program"] = registration.session.program.name
      program["session"] = registration.session.name
      program["division"] = registration.division.name
      programs << program
    end
    programs
  end
  
  def program_name
    program_name = ""
    if self.team
      program_name = self.team.division.program.name
    else
      program_name = "N/A"
    end
  end
  
  def phones
    phones = Array.new
    contacts.each do |contact|
      phones << contact.phones.collect { |p| p.phone_number }
    end
    phones
  end
  
  def email_addresses
    email_addresses = Array.new
    contacts.each do |contact|
      email_addresses << contact.email_address
    end
    email_addresses
  end
  
  def division
    # Assumes a Single Team, consequently Single Division Scenario
    self.team.division
  end
  
  def send_circles_message(circles_message, team)
    primary_contact.send_circles_message(circles_message, team, self)
  end
  
  def update_profile_photo(profile_photo)
    self.profile_photo = profile_photo
    self.save!
  end
  
  def activated?
    if self.primary_contact
     self.primary_contact.user
    else
     nil
    end
  end
  
  def jersey_number(team)
    jersey_number = nil
    self.team_memberships.each do |team_membership|
      if team_membership.team == team
        jersey_number = team_membership.jersey_number
      end
    end
    jersey_number
  end
  
  def set_jersey_number(team, jersey_number)
    self.team_memberships.each do |team_membership|
      if team_membership.team == team
        team_membership.jersey_number = jersey_number
        team_membership.save!
      end
    end
  end
  
  def team_display(team)
    "##{jersey_number(team)}: #{name}"
  end
  
  def regular_season_votes
    self.current_star_player_votes(self.team).reject { |v| v.is_preseason_vote? }
  end
  
  def current_star_player_votes(team)
    star_player_votes.reject { |v| !v.game_report.game.home_team.active_session }
  end
  
  # Setting Name for external teams
  def set_full_name(f_name, l_name)
    self.first_name = f_name
    self.last_name = l_name
    self.save!
  end
  
  # Class Methods
  def self.create_from_dialog(user, hub, params)
    p = Participant.new
    p.title = params[:title]
    p.first_name = params[:first_name]
    p.last_name = params[:last_name]
    p.save
    
    hub.participants << p
    hub.save
    
    r = Registration.create_from_participant_dialog(p, params[:session], params[:division], params[:registered_date], params[:registration_requests])
    primary_contact = Contact.create_from_participant_dialog(p, 
                                                            params[:primary_contact_first_name],
                                                            params[:primary_contact_last_name],
                                                            params[:primary_contact_email_address],
                                                            params[:primary_contact_street_address],
                                                            params[:primary_contact_city],
                                                            params[:primary_contact_state],
                                                            params[:primary_contact_zip],
                                                            params[:primary_contact_primary_phone],
                                                            params[:primary_contact_primary_phone_type],
                                                            params[:primary_contact_secondary_phone],
                                                            params[:primary_contact_secondary_phone_type]);
                                                    
    secondary_contact = Contact.create_from_participant_dialog(p, 
                                                            params[:secondary_contact_first_name],
                                                            params[:secondary_contact_last_name],
                                                            params[:secondary_contact_email_address],
                                                            params[:secondary_contact_street_address],
                                                            params[:secondary_contact_city],
                                                            params[:secondary_contact_state],
                                                            params[:secondary_contact_zip],
                                                            params[:secondary_contact_primary_phone],
                                                            params[:secondary_contact_primary_phone_type],
                                                            params[:secondary_contact_secondary_phone],
                                                            params[:secondary_contact_secondary_phone_type]);
    
      v1 = VolunteerSignup.create_volunteer_signup(primary_contact, r, params[:primary_contact_volunteer])
      v2 = VolunteerSignup.create_volunteer_signup(secondary_contact, r, params[:secondary_contact_volunteer])
                                                            
  end
  
  def self.create_from_confirm_import(hub, params)
    p = Participant.new
    
    if params[:name] 
      p.last_name = params[:name].split(",")[0]
      p.first_name = params[:name].split(",")[1]
    else
      p.first_name = params[:firstname]
      p.last_name = params[:lastname]
    end
    p.save
    
    hub.participants << p
    hub.save
    
    #program = Program.identify_or_create(hub, params[:program])
    #session = Session.identify_or_create(program, params[:session])
    #division = Division.identify_or_create(program, session, params[:division])

    r = Registration.create_from_participant_import(p, params[:session], params[:division], params[:special_requests])
    
    # Create a sample primary contact
    #c = Contact.create_initial_contact(p, params)
    primary_contact = Contact.create_from_participant_dialog(p, 
                                                            params[:primary_contact_first_name],
                                                            params[:primary_contact_last_name],
                                                            params[:primary_contact_email],
                                                            params[:primary_contact_street_address],
                                                            params[:primary_contact_city],
                                                            params[:primary_contact_state],
                                                            params[:primary_contact_zip],
                                                            params[:primary_contact_primary_phone],
                                                            params[:primary_contact_primary_phone_type],
                                                            params[:primary_contact_secondary_phone],
                                                            params[:primary_contact_secondary_phone_type]);
    secondary_contact = Contact.create_from_participant_dialog(p, 
                                                            params[:secondary_contact_first_name],
                                                            params[:secondary_contact_last_name],
                                                            params[:secondary_contact_email],
                                                            params[:secondary_contact_street_address],
                                                            params[:secondary_contact_city],
                                                            params[:secondary_contact_state],
                                                            params[:secondary_contact_zip],
                                                            params[:secondary_contact_primary_phone],
                                                            params[:secondary_contact_primary_phone_type],
                                                            params[:secondary_contact_secondary_phone],
                                                            params[:secondary_contact_secondary_phone_type]);
  end

  
end
