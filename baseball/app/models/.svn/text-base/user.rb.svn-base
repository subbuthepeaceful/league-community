require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  # A web user should be relatd to a Contact in the system
  belongs_to :contact
  
  # A web user has a mailbox
  has_one :mailbox
  

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation

  def self.create_from_contact(c)
    u = User.new
    u.email = c.email_address
    u.login = c.email_address
    
    p = User.random_password
    u.password = p
    
    u.contact = c
    
    u.save_without_validation
        
    [u, p]
  end

  # creates random pronouncable passwords
  def self.random_password
    c = %w( b c d f g h j k l m n p qu r s t v w x z ) +
    %w( ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr )
    v = %w( a e i o u y )
    f, r = true, ''
    6.times do
      r << ( f ? c[ rand * c.size ] : v[ rand * v.size ] )
      f = !f
    end
    2.times do
      r << ( rand( 9 ) + 1 ).to_s
    end
    r
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def is_admin?
    site_admin
  end
  
  def to_s
    first_name + " " + last_name
  end
  
  def name
    if self.contact
      contact.name
    else
      login
    end
  end
  
  def reset_password
    new_password = User.random_password
    self.password = new_password
    self.save_without_validation
    new_password
  end
  
  protected
    


end
