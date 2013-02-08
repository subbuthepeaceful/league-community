class SponsorshipOption < ActiveRecord::Base
  belongs_to :hub
  
  # Instance Methods
  def is_variable_amount?
    self.amount.blank?
  end
  
  # Class Methods
  def self.primary_options(hub)
    primary_options = hub.sponsorship_options.find(:all, :conditions => { :primary => true}, :order => "`group`")
  end
  
  def self.other_options(hub)
    other_options = hub.sponsorship_options.find(:all, :conditions => { :primary => false}, :order => "`group")
  end
end