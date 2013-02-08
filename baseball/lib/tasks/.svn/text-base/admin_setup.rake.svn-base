require 'config/environment'

namespace :lamvpb do
  task :create_admin_setup do
    # Division Director Setup
    division = Division.find_by_name("Mustang-2")
    contact = Contact.find_by_email_address("ed.delfierro@sbcglobal.net")
    contact.assign_as_admin("Division", division, "Director")
    division = Division.find_by_name("Mustang-1")
    contact = Contact.find_by_email_address("rjrpelayo@aol.com")
    contact.assign_as_admin("Division", division, "Director")
    division = Division.find_by_name("Pinto-2")
    contact = Contact.find_by_email_address("byroncyoung@sbcglobal.net")
    contact.assign_as_admin("Division", division, "Director")
    hub = Hub.find_by_url_prefix("lamvpb")
    contact = Contact.find_by_email_address("rbsiegel@earthlink.net")
    contact.assign_as_admin("Hub", hub, "League Executive")
  end
end