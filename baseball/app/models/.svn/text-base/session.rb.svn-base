class Session < ActiveRecord::Base
  belongs_to :program
  has_many :registrations
  has_many :teams
  has_many :events
  
  # Instance Methods
  def start
    start_date
  end
  
  def end
    end_date
  end
  
  def title
    program.name + " - " + name
  end
  
  def className
    "program"
  end
  
  def self.create_session_for_program(program, params)
    session = Session.new
    session.name = params[:name]
    session.status = params[:status]
    session.start_date = params[:start_date]
    session.end_date = params[:end_date]
    session.program = program
    session.save!
  end
  
  def self.identify_or_create(program, session)
    s = program.sessions.find_by_name(session)
  end
  
end