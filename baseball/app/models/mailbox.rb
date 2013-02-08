class Mailbox < ActiveRecord::Base
  belongs_to :contact
  has_many :mailbox_messages
  has_many :circles_messages, :through => :mailbox_messages, :order => "sent DESC"
  
  def messages
    self.circles_messages
  end
  
  def inbox
    self.messages.first(5)
  end
  
  def full_inbox
    self.messages
  end
  
  def add(circles_message)
    circles_messages << circles_message
    self.save!
  end
end