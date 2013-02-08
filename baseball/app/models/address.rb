class Address < ActiveRecord::Base
  belongs_to :contact
  
  def self.create_from_params(contact, street_address, city, state, zip)
    a = Address.new
    a.contact = contact
    
    a.street_address = street_address
    a.city = city
    a.state = state
    a.zip_code = zip
    a.save
  end
end