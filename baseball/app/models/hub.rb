class Hub < ActiveRecord::Base
  has_many :programs
  has_and_belongs_to_many :participants
  has_many :locations
  has_many :hub_assets
  has_many :sponsors
  has_many :sponsorship_options
  
  has_many :circle_options
  
  acts_as_tree
  
  def available_programs
    programs
  end
  
  def has_header_banner?
    self.hub_assets.each do |ha|
      if ha.name.eql? "Header Banner"
        return true
      end
    end
    return false
  end
  
  def header_banner
    self.hub_assets.each do |ha|
      if ha.name.eql? "Header Banner"
        return ha
      end
    end
    return nil
  end
  
  def has_multiple_programs?
    self.program_variant =~ /Multi-program/
  end
  
  def has_multiple_seasons?
    self.program_variant =~ /Multi-season/
  end
  
  def has_multiple_divisions?
    self.default_program.divisions.size > 1
  end
  
  def default_program
    programs[0] if programs
  end
  
  def messages_enabled?
    option_enabled?("MESSAGES")
  end
  
  def pictures_enabled?
    option_enabled?("PICTURES")
  end

  def resources_enabled?
    option_enabled?("RESOURCES")
  end

  def sponsors_enabled?
    option_enabled?("SPONSORS")
  end
  
  def promo_enabled?
    option_enabled?("CIRCLES_PROMO")
  end
  
  protected
  def option_enabled?(option_name)
    if circle_options && circle_options.size > 0
      co = circle_options.find_by_option_name(option_name)
      if co && co.option_name == option_name
        return co.option_value
      end
    end
    return nil
  end
  
end