module CirclesScheduler
  
  DATE_MATCH_PATTERN = /(\d+)\/(\d+)\/(\d+)/
  TIME_MATCH_PATTERN = /(\d+)([:])(\d+)([:]*)(\d+)?[ ]*(AM|PM)/
  
  def create_calendar_slots(start_date, end_date, day_of_the_week, time_slot)
    puts "Creating Slots from #{start_date} to #{end_date} on #{day_of_the_week}s at #{time_slot}"
    
    # First we navigate to the beginning of the week of the start date
    beginning_of_start_week = start_date.beginning_of_week
    beginning_of_end_week = end_date.beginning_of_week  
    current_week = beginning_of_start_week
    
    time_slots = Array.new
    
    while current_week <= beginning_of_end_week
      puts "#{current_week}"
      
      day_offset = DAYS_OF_THE_WEEK.index(day_of_the_week)
      puts "#{day_of_the_week} : #{day_offset}"
      
      time_slot_for_week = current_week.advance({:days => day_offset})
      puts "#{time_slot_for_week}"
      
      time_components = time_slot.match(TIME_MATCH_PATTERN)
      
      hour_offset = time_components[1].to_i
      if time_components[4] == "PM" && hour_offset < 12
        hour_offset += 12
      end
      
      minutes_offset = time_components[3].to_i
      
      time_slot_for_week = time_slot_for_week.advance({:hours => hour_offset, :minutes => minutes_offset})
      puts "#{time_slot_for_week}"
      
      time_slots << time_slot_for_week
      
      current_week = current_week.next_week
      
    end
    time_slots
  end
  
  def change_calendar_slot(current_date_time, new_date, new_time)
    new_date_components = new_date.match(DATE_MATCH_PATTERN)
    new_month = new_date_components[1].to_i
    new_day = new_date_components[2].to_i
    new_year = new_date_components[3].to_i
    new_time_components = new_time.match(TIME_MATCH_PATTERN)
    new_hour = new_time_components[1].to_i
    if (new_time_components[4] == "PM" || new_time_components[6] == "PM") && new_hour < 12
      new_hour += 12
    end
      
    new_minutes = new_time_components[3].to_i
    puts "Original Date Time #{current_date_time}"
    if current_date_time.nil?
      current_date_time = DateTime.now
    end
    new_date_time = current_date_time.change({:year => new_year, :month => new_month, :day => new_day, :hour => new_hour, :min => new_minutes})
    
    if ENV['MODE'] && ENV['MODE'] == "BATCH"
      new_date_time = new_date_time.advance({:hours => 7})
    end
    
    puts "New Date Time #{new_date_time}"
    new_date_time
  end
  
  def create_calendar_entry(calendar_date, event_time)
    calendar_entry = calendar_date
    if !event_time.blank?
      event_time_components = event_time.match(TIME_MATCH_PATTERN)
      event_hour = event_time_components[1].to_i
      if event_time_components[4] == "PM" && event_hour < 12
        event_hour += 12
      end
      event_minutes = event_time_components[3].to_i
      calendar_entry = calendar_date.advance({:hours => event_hour, :minutes => event_minutes})
    end
    puts "Creating Calendar Entry for #{calendar_entry}"
    calendar_entry
  end
  
end