class Phone < ActiveRecord::Base
  belongs_to :contact
  
  def self.create_from_params(contact, phone_number, phone_type)
    p = Phone.new
    p.contact = contact
    
    p.phone_number = phone_number
    p.phone_type = phone_type
    
    p.save
  end
end