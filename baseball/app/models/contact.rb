class Contact < ActiveRecord::Base
  has_one :user
  has_many :addresses
  has_many :phones
  has_and_belongs_to_many :participants
  has_many :volunteer_signups
  
  has_one :mailbox
  
  has_attached_file :profile_photo, :styles => { :thumb => "66x76#", :small => "132x152" }
  
  has_many :game_reports
  has_many :admin_roles
  
  def name
    first_name + " " + last_name
  end
  
  def volunteer_role
    if self.volunteer_signups && self.volunteer_signups.size > 0
      self.volunteer_signups[0].role
    else
      ""
    end
  end
  
  def find_participants_for_team_division(division, session)
    participants_for_division = Array.new
    participants.each do |participant|
      if participant.has_registration_for_division_and_session(division, session)
        participants_for_division << participant
      end
    end
    participants_for_division
  end
  
  def phone
    if phones
      phones[0].phone_number
    else
      nil
    end
  end
  
  def activate_online_access(participant, registration, subject, message)
    puts "Activating #{name} for #{participant.name} with access to #{registration.to_s}"
    unless self.user
      u,p = User.create_from_contact(self)
      puts "User #{u.login} created with password #{p}"
      if ACTIVATION_MAIL_ENABLED
        UserMailer.deliver_activate_notification(u, 
                                                p, 
                                                registration.division, 
                                                registration.session, 
                                                registration.session.program, 
                                                registration.session.program.hub, 
                                                participant, 
                                                subject, 
                                                message)
      end
    
      # Create a mailbox
      mbox = Mailbox.new
      mbox.contact = self
      mbox.save!
    end
  end
  
  def resend_activation(participant, registration, subject)
    if self.user
      new_password = self.user.reset_password
      puts "User #{self.user.login} reset with password #{new_password}"
      if ACTIVATION_MAIL_ENABLED
        UserMailer.deliver_activate_notification(self.user,
                                               new_password,
                                               registration.division, 
                                               registration.session, 
                                               registration.session.program, 
                                               registration.session.program.hub, 
                                               participant, 
                                               subject, 
                                               nil)
      end
    end
  end
  
  def send_game_reminder(participant, game)
    puts "Sending  #{name} reminder for #{game.email_title}" 
    UserMailer.deliver_game_reminder(user,game, participant)
  end
  
  def default_participant
    if self.user.is_admin?
      return Participant.find(:first)
    else
      if participants.size > 0
        participants.each do |p|
          if p.has_registration_for_session(p.hubs[0].default_program.currently_active_session)
            return p
          end
        end
      end
    end
  end
  
  def send_circles_message(circles_message, team, participant)
    #unless circles_message.contact == self
      self.mailbox.add(circles_message)
      UserMailer.deliver_circles_message(self, team, participant, circles_message)
    #end
  end
  
  def update_profile_photo(profile_photo)
    self.profile_photo = profile_photo
    self.save!
  end
  
  def assign_as_admin(classification, identifier, role_title)
    admin_role = AdminRole.new
    admin_role.contact = self
    admin_role.admin_classification = classification
    admin_role.admin_instance = identifier.id
    admin_role.role_title = role_title
    admin_role.save!
  end
  
  def has_admin_role?
    self.admin_roles.size > 0
  end
  
  def admin_visibility
    # We need to resolve what exactly this contact has visibility for
    # Keep it simple for the moment and focus on Division Visibility
    visibility = []
    self.admin_roles.each do |admin_role|
      visibility << admin_role.resolve
    end
    visibility
  end
  
  def no_participants?
    self.participants == nil || self.participants.size == 0
  end
  
  def has_participants?
    self.participants && self.participants.size > 0
  end
  
  # Class Methods
  def self.create_from_participant_dialog(participant, 
                                          first_name, 
                                          last_name, 
                                          email_address, 
                                          street_address, 
                                          city, 
                                          state, 
                                          zip, 
                                          primary_phone, 
                                          primary_phone_type, 
                                          secondary_phone, 
                                          secondary_phone_type)
  
    c = Contact.find_by_email_address(email_address)
    unless c
      c = Contact.new
      if first_name.blank?
        c.first_name = "<Parent>"
      else
        c.first_name = first_name
      end
      if last_name.blank?
        c.last_name = participant.last_name
      else
        c.last_name = last_name
      end
      c.email_address = email_address

      c.save!
      a = Address.create_from_params(c, street_address, city, state, zip)
      p = Phone.create_from_params(c, primary_phone, primary_phone_type)
      #s = Phone.create_from_params(c, secondary_phone, secondary_phone_type)
    end
    c.participants << participant
    c
  end
  
  def self.create_initial_contact(participant, params)
    c = Contact.find_by_email_address(params[:email])
    unless c
      c = Contact.new
      c.first_name = params[:firstname]
      c.last_name = params[:lastname]
      
      c.email_address = params[:email]
      
      # TEMPORARY EMAIL CONSTRUCTION FOR TEST
      if RAILS_ENV == "development" || RAILS_ENV == "test"
        c.email_address = params[:firstname] + "_" + params[:lastname] + "@somedomain.com"
      end
      
      c.save!
      
      if params[:address]
        # This is a consolidated address
        address_components = params[:address].split(",")
        a = Address.create_from_params(c, address_components[0].strip, address_components[1].strip, address_components[2].strip, address_components[3].strip)
      else
        a = Address.create_from_params(c, params[:street_address], params[:city], params[:state], params[:zip_code])
      end
        
      p = Phone.create_from_params(c, params[:home_phone], "Home")
    end
    c.participants << participant
    c
  end
end
