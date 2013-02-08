class VolunteerSignup < ActiveRecord::Base
  belongs_to :registration
  belongs_to :contact
  
  def self.create_volunteer_signup(contact, registration, volunteer_role)
    v = VolunteerSignup.new
    v.contact = contact
    v.registration = registration
    v.role = volunteer_role
    v.save!
  end
end