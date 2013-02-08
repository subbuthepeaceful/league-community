class Location < ActiveRecord::Base
  has_many :games
  has_many :events
  belongs_to :hub
  
  #Instance Methods
  def address
    street_address + "," + city + "," + state + "," + zip_code
  end
  
  def to_s
    name
  end
  
  def self.create_from_dialog(hub, params)
    l = Location.new
    l.name = params[:name]
    l.street_address = params[:street_address]
    l.city = params[:city]
    l.state = params[:state]
    l.zip_code = params[:zip_code]
    l.comments = params[:comments]

    l.hub = hub
    l.save
  end
  
end