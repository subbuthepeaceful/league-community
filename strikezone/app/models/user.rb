class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :superadmin
  # attr_accessible :title, :body

  has_many :roles
  has_many :teams, :through => :roles

  # The following method is needed because while creating users through the admin
  # a password will not be generated 
  # http://net.tutsplus.com/tutorials/ruby/create-beautiful-administration-interfaces-with-active-admin/
  def password_required?
    new_record? ? false : super
  end

  def name
    "#{first_name} #{last_name}"
  end

  def sorted_teams
    teams.uniq.sort { |a,b| a.age_group.name <=> b.age_group.name }
  end

  def calendars
    @calendars = []
    # Lets assume that a person is not going to be a coach and a manager
    if self.is_coach?
      @calendars << self
    else
      # Find all the coaches who are coaching my teams
      teams.map { |t| @calendars << t.coach_as_member }
    end
    @calendars
  end

  def calendar
    @entries = {}

    self.teams.each do |team|

      team.games.each do |game|
        if !(@entries.has_key?(game.game_date))
          @entries[game.game_date] = []
        end 
        @entries[game.game_date] << game
        @entries[game.game_date].sort! { |x,y| (x.game_time ? x.game_time : Time.now) <=> (y.game_time ? y.game_time : Time.now) }
      end
    end
    @entries.sort
  end

  def fields
    @fields = []

    teams.map { |t| @fields << t.age_group.fields }

    @fields.flatten!.uniq!
    @fields
  end

  def other_fields
    all_fields = Field.in_use
    fields.each do |f|
      all_fields.delete(f)
    end
    all_fields
  end

  def other_teams
    other_teams = []
    sorted_teams.each do |t|
      other_teams << t.related_teams
    end
    other_teams.flatten!.uniq!.sort { |a,b| a.age_group.name <=> b.age_group.name }
  end

  def is_coach?
    (roles.select { |r| r.name == "Coach"}).empty? ? false : true
  end
end
