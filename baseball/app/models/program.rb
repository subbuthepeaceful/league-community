class Program < ActiveRecord::Base
  belongs_to :hub
  has_many :sessions
  has_many :divisions
  
  acts_as_tree
  
  validates_presence_of :name
  
  # Class Methods
  def self.active_programs(hub)
    hub.programs
  end
  
  def self.program_groups_for_select(hub)
    program_groups = []
    program_groups << "None"
    hub.programs.each do |p|
     program_groups << p.name
    end 
    program_groups
  end
  
  def self.create_from_dialog(user, hub, params)
    p = Program.new
    p.name = params[:name]
    p.description = params[:description]
    p.status = params[:status]
    p.created_on = Date.today
    p.created_by = user.to_s
    if params[:parent] == "None"
      p.parent = nil
    else
      parent_program = Program.find_by_name(params[:parent])
      p.parent = parent_program
    end
    p.hub = hub
    p.save
  end
  
  def self.identify_or_create(hub, program)
    p = Program.find_by_name(program)
    unless p
      p = Program.new
      p.name = program
      p.description = program
      p.status = "Active"
      p.created_on = Date.today
      p.created_by = "Imported"
      p.parent = nil
      p.hub = hub
      p.save
    end
    p
  end
  
  # Instance Methods
  def currently_active_session
    sessions.find(:first, :conditions => { :status => "Active"})
  end
  
  def to_s
    name
  end
end