class Registration < ActiveRecord::Base
  belongs_to :participant
  belongs_to :session
  belongs_to :division
  has_many :volunteer_signups
  
  # Class Methods
  def self.create_from_participant_dialog(participant, session_id, division_id, registered_date, registration_requests)
    r = Registration.new
    r.participant = participant
    
    s = Session.find(session_id)
    r.session = s
    
    d = Division.find(division_id)
    r.division = d
    
    r.registered_date = registered_date
    r.registration_requests = registration_requests
    r.save
    r
  end
  
  def self.create_from_participant_import(participant, session, division, special_requests)
    r = Registration.new
    r.participant = participant
    r.session = session
    r.division = division
    r.registration_requests = special_requests
    r.registered_date = Date.today
    r.save
    r
  end
  
  # Instance Methods
  def to_s
    division.name + " : " + session.name
  end
  
  def name
    participant.name
  end
  
  def primary_contact
    participant.primary_contact
  end
  
end