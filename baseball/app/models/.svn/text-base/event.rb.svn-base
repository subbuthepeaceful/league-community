class Event < ActiveRecord::Base
  belongs_to :session
  belongs_to :location
  belongs_to :division
  
  include CirclesScheduler  
  # Instance Methods
  def set_start_date_time(calendar_date, calendar_time)
    self.starts = calendar_date
    self.starts = create_calendar_entry(self.starts, calendar_time)
  end
  
  def set_end_date_time(calendar_date, calendar_time)
    self.ends = calendar_date
    self.ends = create_calendar_entry(self.ends, calendar_time)
  end
  
  def start
    starts
  end
  
  def end
    ends
  end
  
  def className
    "session"
  end
  
  def eventType
    "Event"
  end
  
  def title
    title = self.name
    if self.location
      title += " @ #{self.location.name}"
    end
    title
  end
  
  # Class Methods
  def self.create_from_dialog(session, params)
    e = Event.new
    
    e.session = session
    e.name = params[:name]
    
    e.set_start_date_time(params[:start_date], params[:start_time])
    e.set_end_date_time(params[:end_date], params[:end_time])
    
    if !params[:location].blank?
      location = Location.find_by_name(params[:location])
      if location
        e.location = location
      end
    end
    
    e.description = params[:description]
    e.save
  end

  def self.create_division_event_from_dialog(division, params)
    e = Event.new
    
    e.division = division
    e.name = params[:name]
    
    e.set_start_date_time(params[:start_date], params[:start_time])
    e.set_end_date_time(params[:end_date], params[:end_time])
    
    if !params[:location].blank?
      location = Location.find_by_name(params[:location])
      if location
        e.location = location
      end
    end
    
    e.description = params[:description]
    e.save
  end
  
end